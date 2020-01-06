# frozen_string_literal: true

module Zoom
  module Actions
    module Phone
      def phone_recording_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id)
        Utils.parse_response self.class.get("/phone/users/#{params[:id]}/recordings", query: params.except(:id), headers: request_headers)
      end

      def phone_user_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.permit(%i[page_size page_number])
        response = self.class.get('/phone/users', query: params, headers: request_headers)
        Utils.parse_response(response)
      end
    end
  end
end
