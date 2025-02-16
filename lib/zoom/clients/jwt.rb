# frozen_string_literal: true
require 'jwt'
require 'logger'

module Zoom
  class Client
    class JWT < Zoom::Client

      def initialize(config)
        ::Logger.new(STDOUT).warn('Zoom::Client::JWT is deprecated. Please use Zoom::Client::ServerToServerOAuth instead. See: https://developers.zoom.us/docs/internal-apps/jwt-faq/')
        Zoom::Params.new(config).require(:api_key, :api_secret)
        extract_params(config)
        self.class.default_timeout(@timeout || 20)
      end

      def access_token
        ::JWT.encode({ iss: @api_key, exp: Time.now.to_i + @timeout }, @api_secret, 'HS256', { typ: 'JWT' })
      end
    end
  end
end
