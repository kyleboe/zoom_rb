# frozen_string_literal: true

module Zoom
  class Client
    class OAuth < Zoom::Client
      # Auth_token is sent in the header
      # (auth_code, auth_token, redirect_uri) -> oauth API
      # Returns (access_token, refresh_token)
      #
      # (auth_token, refresh_token) -> oauth refresh API
      # Returns (access_token, refresh_token)
      #
      def initialize(config)
        Zoom::Params.new(config).permit( %i[store_key auth_token auth_code redirect_uri access_token refresh_token timeout code_verifier])
        Zoom::Params.new(config).require_one_of(%i[access_token refresh_token auth_code])
        if (config.keys & [:auth_code, :redirect_uri]).any?
          Zoom::Params.new(config).require( %i[auth_code redirect_uri])
        end

        extract_params(config)

        self.class.default_timeout(@timeout || 20)
      end

      def auth
        refresh_token ? refresh : oauth
      end

      def refresh
        response = refresh_tokens(grant_type: 'refresh_token', refresh_token: refresh_token)
        set_tokens(response)
        response
      end

      def oauth
        response = access_tokens(
          grant_type: 'authorization_code',
          auth_code: @auth_code,
          redirect_uri: @redirect_uri,
          code_verifier: @code_verifier
        )

        set_tokens(response)
        response
      end

      def revoke
        response = revoke_tokens(access_token: access_token)
        set_tokens(response)
        response
      end

      private

      def set_tokens(response)
        if response.is_a?(Hash) && !response.key?(:error)
          token_store.access_token = response["access_token"]
          token_store.refresh_token = response["refresh_token"]
          token_store.expires_in = response["expires_in"]
          token_store.expires_at = expires_in ? (Time.now + expires_in).to_i : nil
        end
      end
    end
  end
end
