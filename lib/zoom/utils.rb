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

      def raise_error(response, http_code=nil, headers=nil)
        code = response['code']
        message = response['message']
        errors = response['errors']

        case http_code
        when 400
          raise BadRequest.new(message, code, errors, headers)
        when 401
          raise Unauthorized.new(message, code, errors, headers)
        when 403
          raise Forbidden.new(message, code, errors, headers)
        when 404
          raise NotFound.new(message, code, errors, headers)
        when 409
          raise Conflict.new(message, code, errors, headers)
        when 429
          raise TooManyRequests.new(message, code, errors, headers)
        when 500
          raise InternalServerError.new(message, code, errors, headers)
        else
          raise Error.new(message, code, errors, headers)
        end
      end

      def parse_response(http_response)
        return http_response.parsed_response || http_response.code if http_response.success?
        raise_error(http_response.parsed_response, http_response.code, http_response.headers)
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
