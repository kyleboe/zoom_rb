# frozen_string_literal: true

module Zoom
  module Actions
    module Data
      def compliance(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        require_param_keys = %i[client_id user_id account_id deauthorization_event_received compliance_completed]
        params.require(require_param_keys)
        Utils.parse_response self.class.post('/oauth/data/compliance', body: params.to_json, headers: request_headers)
      end
    end
  end
end
