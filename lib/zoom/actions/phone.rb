# frozen_string_literal: true

module Zoom
  module Actions
    module Phone
      def phone_recording_list(*args)
        options = Utils.extract_options!(args)
        Utils.process_datetime_params!(%i[from to], options)

        params = Zoom::Params.new(options)
        params.require(:id)
        Utils.parse_response self.class.get("/phone/users/#{params[:id]}/recordings", query: params.except(:id), headers: request_headers)
      end
    end
  end
end
