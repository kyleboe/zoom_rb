# frozen_string_literal: true

module Zoom
  class Utils
    class << self
      def argument_error(name)
        name ? ArgumentError.new("You must provide #{name}") : ArgumentError.new
      end

      def exclude_argument_error(name)
        name ? ArgumentError.new("Unrecognized parameter #{name}") : ArgumentError.new
      end

      def raise_if_error!(response, http_code=200)
        return response unless response.is_a?(Hash) && response.key?('code')

        code = response['code']
        message = build_error(response)

        raise AuthenticationError, message if code == 124
        raise BadRequest, message if code == 400
        raise Unauthorized, message if code == 401
        raise Forbidden, message if code == 403
        raise NotFound, message if code == 404
        raise Conflict, message if code == 409
        raise TooManyRequests, message if code == 429
        raise InternalServerError, message if code == 500
        raise Error.new(message, message)
      end

      def build_error(response)
        message = response['message']
        if response['errors']
          "#{message}: #{response['errors'].join(', ')}"
        else
          message
        end
      end

      def parse_response(http_response)
        raise_if_error!(http_response.parsed_response, http_response.code) || http_response.code
      end

      def extract_options!(array)
        params = array.last.is_a?(::Hash) ? array.pop : {}
        process_datetime_params!(params)
      end

      def validate_password(password)
        password_regex = /\A[a-zA-Z0-9@-_*]{0,10}\z/
        raise(Error , 'Invalid Password') unless password[password_regex].nil?
      end

      def process_datetime_params!(params)
        params.each do |key, value|
          case key
          when Symbol, String
            params[key] = value.is_a?(Time) ? value.strftime('%FT%TZ') : value
          when Hash
            process_datetime_params!(params[key])
          end
        end
        params
      end
    end
  end
end
