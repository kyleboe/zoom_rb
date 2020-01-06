# frozen_string_literal: true

module Zoom
  module Actions
    module Phone
      def recording_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id)
        Utils.parse_response self.class.get("/phone/users/#{params[:id]}/recordings", query: params.except(:id), headers: request_headers)
      end
    end
  end
end
