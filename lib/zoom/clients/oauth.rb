# frozen_string_literal: true

module Zoom
  class Client
    class OAuth < Zoom::Client
      attr_reader :access_token, :refresh_token, :expires_in, :expires_at

      # Auth_token is sent in the header
      # (auth_code, auth_token, redirect_uri) -> oauth API
      # Returns (access_token, refresh_token)
      #
      # (auth_token, refresh_token) -> oauth refresh API
      # Returns (access_token, refresh_token)
      #
      def initialize(config)
        Zoom::Params.new(config).permit( %i[auth_token auth_code redirect_uri access_token refresh_token timeout code_verifier])
        Zoom::Params.new(config).require_one_of(%i[access_token refresh_token auth_code])
        if (config.keys & [:auth_code, :redirect_uri]).any?
          Zoom::Params.new(config).require( %i[auth_code redirect_uri])
        end

        config.each { |k, v| instance_variable_set("@#{k}", v) }
        self.class.default_timeout(@timeout || 20)
      end

      def auth
        refresh_token ? refresh : oauth
      end

      def refresh
        response = refresh_tokens(grant_type: 'refresh_token', refresh_token: @refresh_token)
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
        response = revoke_tokens(access_token: @access_token)
        set_tokens(response)
        response
      end

      private

      def set_tokens(response)
        if response.is_a?(Hash) && !response.key?(:error)
          @access_token = response["access_token"]
          @refresh_token = response["refresh_token"]
          @expires_in = response["expires_in"]
          @expires_at = @expires_in ? (Time.now + @expires_in).to_i : nil
        end
      end
    end
  end
end
