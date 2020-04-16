# frozen_string_literal: true
#
module Zoom
  module Actions
    module Token
      # Get the OAuth access tokens
      def access_tokens(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[authorisation_code redirect_uri])
        Utils.parse_response self.class.post("/oauth/token?grant_type=authorization_code&code=#{options[:authorisation_code]}&redirect_uri=#{options[:redirect_uri]}", headers: oauth_request_headers, base_uri: 'https://zoom.us/')
      end
    end
  end
end
