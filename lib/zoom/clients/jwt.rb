# frozen_string_literal: true

require "jwt"

module Zoom
  class Client
    class JWT < Zoom::Client
      def initialize(config)
        Zoom::Params.new(config).require(:api_key, :api_secret)
        config.each { |k, v| instance_variable_set("@#{k}", v) }
        self.class.default_timeout(@timeout || 20)
      end

      def access_token
        ::JWT.encode({iss: @api_key, exp: Time.now.to_i + @timeout}, @api_secret, "HS256", {typ: "JWT"})
      end
    end
  end
end
