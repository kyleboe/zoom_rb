# frozen_string_literal: true

module Zoom
  class Client
    class ServerToServerOAuth < Zoom::Client
      attr_reader :access_token, :expires_in, :expires_at

      def initialize(config)
        Zoom::Params.new(config).permit(%i[access_token account_id client_id client_secret timeout])
        Zoom::Params.new(config).require_one_of(%i[access_token account_id])

        config.each { |k, v| instance_variable_set("@#{k}", v) }
        self.class.default_timeout(@timeout || 20)
      end

      def auth
        response = access_tokens_account_credentials(account_id: @account_id)
        set_tokens(response)
        response
      end

      def auth_token
        return Base64.urlsafe_encode64("#{@client_id}:#{@client_secret}") if @client_id && @client_secret

        Base64.urlsafe_encode64("#{Zoom.configuration.api_key}:#{Zoom.configuration.api_secret}")
      end

      private

      def set_tokens(response)
        if response.is_a?(Hash) && !response.key?(:error)
          @access_token = response["access_token"]
          @expires_in = response["expires_in"]
          @expires_at = @expires_in ? (Time.now + @expires_in).to_i : nil
        end
      end
    end
  end
end
