# frozen_string_literal: true

module Zoom
  module Actions
    module SipAudio
      def sip_trunks_get(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:account_id)
        Utils.parse_response self.class.get("/accounts/#{params[:account_id]}/sip_trunk/trunks", headers: request_headers)
      end

      def sip_trunks_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:account_id, :trunk_id)
        Utils.parse_response self.class.delete("/accounts/#{params[:account_id]}/sip_trunk/trunks/#{params[:trunk_id]}", headers: request_headers)
      end

      def sip_trunk_numbers_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:account_id)
        Utils.parse_response self.class.delete("/accounts/#{params[:account_id]}/sip_trunk/numbers", headers: request_headers)
      end

      def sip_trunks_internal_numbers_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:account_id, :number_id)
        Utils.parse_response self.class.delete("/accounts/#{params[:account_id]}/sip_trunk/internal_numbers/#{params[:number_id]}", headers: request_headers)
      end

      def sip_trunks_internal_callout_country_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:account_id, :country_id)
        Utils.parse_response self.class.delete("/accounts/#{params[:account_id]}/sip_trunk/callout_countries/#{params[:country_id]}", headers: request_headers)
      end
    end
  end
end
