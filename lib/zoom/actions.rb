# frozen_string_literal: true

module Zoom
  module Actions
    def self.extract_path_keys(path)
      path.scan(/:\w+/).map { |match| match[1..-1].to_sym }
    end

    def self.parse_path(path, path_keys, params)
      parsed_path = path.dup
      path_keys.each do |key|
        value        = params[key].to_s
        parsed_path  = parsed_path.sub(":#{key}", value)
      end
      parsed_path
    end

    def self.determine_request_options(client, oauth)
      if oauth
        {
          headers: client.oauth_request_headers,
          base_uri: 'https://zoom.us/'
        }
      else
        { headers: client.request_headers }
      end
    end

    def self.make_request(args)
      client, method, parsed_path, params, request_options, oauth =
        args.values_at :client, :method, :parsed_path, :params, :request_options, :oauth
      case method
      when :get, :delete
        request_options[:query] = params
      when :post, :put, :patch
        request_options[:body] =
          oauth ? URI.encode_www_form(params.to_a) : params.to_json
      end
      client.class.public_send(method, parsed_path, **request_options)
    end

    [:get, :post, :patch, :put, :delete].each do |method|
      define_method(method) do |name, path, options={}|
        required, permitted, oauth, args_to_params, headers =
          options.values_at :require, :permit, :oauth, :args_to_params, :headers
        required = Array(required) unless required.is_a?(Hash)
        permitted = Array(permitted) unless permitted.is_a?(Hash)

        define_method(name) do |*args|
          path_keys = Zoom::Actions.extract_path_keys(path)
          params = Utils.extract_options!(args)
          args_to_params&.each { |key, value| params[value] = params.delete key if params[key] }
          params = Zoom::Params.new(params)
          parsed_path = Zoom::Actions.parse_path(path, path_keys, params)
          request_options = Zoom::Actions.determine_request_options(self, oauth)
          params = params.require(path_keys) unless path_keys.empty?
          params_without_required = required.empty? ? params : params.require(required)
          params_without_required.permit(permitted) unless permitted.empty?
          response = Zoom::Actions.make_request({
            client: self, method: method, parsed_path: parsed_path,
            params: params, request_options: request_options, oauth: oauth
          })
          Utils.parse_response(response)
        end
      end
    end
  end
end
