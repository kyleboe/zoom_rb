# frozen_string_literal: true

module Zoom
  class Client
    class OAuth < Zoom::Client
      def initialize(config)
        Zoom::Params.new(config).require(:access_token, :authorisation_code, :redirect_uri)
        config.each { |k, v| instance_variable_set("@#{k}", v) }
        self.class.default_timeout(@timeout || 20)
        oauth
      end

      # Access token changes after the oauth call
      def access_token
        @access_token
      end

      def oauth
        response = access_tokens(authorisation_code: @authorisation_code,
                                 redirect_uri: @redirect_uri)
        unless response.key(:error)
          @access_token = response["access_token"]
          @refresh_token = response["refesh_token"]
        end
      end
    end
  end
end
