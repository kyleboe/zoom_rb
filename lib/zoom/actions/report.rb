# frozen_string_literal: true

module Zoom
  module Actions
    module Report
      def daily_report(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.permit(%i[year month])
        Utils.parse_response self.class.get('/report/daily', query: params, headers: request_headers)
      end

      def hosts_report(*args)
        # TODO: implement hosts_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'hosts_report is not yet implemented'
      end

      def meetings_report(*args)
        # TODO: implement meetings_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'meetings_report is not yet implemented'
      end

      def meeting_details_report(*args)
        # TODO: implement meeting_details_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'meeting_details_report is not yet implemented'
      end

      def meeting_participants_report(*args)
        # TODO: implement meeting_participants_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'meeting_participants_report is not yet implemented'
      end

      def meeting_polls_report(*args)
        # TODO: implement meeting_polls_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'meeting_polls_report is not yet implemented'
      end

      def webinar_details_report(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[page_size next_page_token])
        Utils.parse_response self.class.get("/report/webinars/#{params[:id]}", query: params.except(:id), headers: request_headers)
      end

      def webinar_participants_report(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[page_size next_page_token])
        Utils.parse_response self.class.get("/report/webinars/#{params[:id]}/participants", query: params.except(:id), headers: request_headers)
      end

      def webinar_polls_report(*args)
        # TODO: implement webinar_polls_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'webinar_polls_report is not yet implemented'
      end

      def webinar_qa_report(*args)
        # TODO: implement webinar_qa_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'webinar_qa_report is not yet implemented'
      end

      def telephone_report(*args)
        # TODO: implement telephone_report
        # params = Zoom::Params.new(Utils.extract_options!(args))
        raise Zoom::NotImplemented, 'telephone_report is not yet implemented'
      end
    end
  end
end
