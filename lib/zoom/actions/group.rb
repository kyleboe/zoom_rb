# frozen_string_literal: true

module Zoom
  module Actions
    module Group
      def group_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.permit(%i[page_size page_number])
        response = self.class.get('/groups/#{params[:id]}/members', query: params, headers: request_headers)
        Utils.parse_response(response)
      end
    end
  end
end
