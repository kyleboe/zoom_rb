# frozen_string_literal: true

module Zoom
  module Actions
    module Webinar
      RECURRENCE_KEYS = %i[type repeat_interval weekly_days monthly_day monthly_week
                           monthly_week_day end_times end_date_time].freeze
      SETTINGS_KEYS = %i[panelists_video practice_session hd_video approval_type
                         registration_type audio auto_recording enforce_login
                         enforce_login_domains alternative_hosts close_registration
                         show_share_button allow_multiple_devices registrants_confirmation_email].freeze
      def webinar_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:host_id).permit(:page_size, :page_number)
        Utils.parse_response self.class.get("/users/#{params[:host_id]}/webinars", query: params, headers: request_headers)
      end

      def webinar_create(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:host_id).permit(:topic, :type, :start_time, :duration,
                                        :timezone, :password, :agenda,
                                        recurrence: RECURRENCE_KEYS,
                                        settings: SETTINGS_KEYS)
        # process recurrence keys based on constants
        # process settings keys based on constants
        Utils.parse_response self.class.post("/users/#{params[:host_id]}/webinars", body: params.except(:host_id).to_json, headers: request_headers)
      end

      def webinar_get(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id)
        Utils.parse_response self.class.get("/webinars/#{params[:id]}", headers: request_headers)
      end

      def webinar_update(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(:topic, :type, :start_time, :duration,
                                   :timezone, :password, :agenda,
                                   recurrence: RECURRENCE_KEYS,
                                   settings: SETTINGS_KEYS)
        Utils.parse_response self.class.patch("/webinars/#{params[:id]}", body: params.except(:id).to_json, headers: request_headers)
      end

      def webinar_delete(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(:occurrence_id)
        Utils.parse_response self.class.delete("/webinars/#{params[:id]}", query: params.except(:id), headers: request_headers)
      end

      def webinar_status_update(*args)
        # TODO: implement webinar_panelists_list
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'webinar_status_update is not yet implemented'
      end

      def webinar_panelists_list(*args)
        # TODO: implement webinar_panelists_list
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'webinar_panelists_list is not yet implemented'
      end

      def webinar_panelist_add(*args)
        # TODO: implement webinar_panelist_add
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'webinar_panelist_add is not yet implemented'
      end

      def webinar_panelists_delete_all(*args)
        # TODO: implement webinar_panelists_delete_all
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'webinar_panelists_delete_all is not yet implemented'
      end

      def webinar_panelist_delete(*args)
        # TODO: implement webinar_panelist_delete
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'webinar_panelist_delete is not yet implemented'
      end

      def webinar_registrants_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id).permit(%i[occurrence_id status page_size page_number])
        Utils.parse_response self.class.get("/webinars/#{params[:id]}/registrants", query: params.except(:id), headers: request_headers)
      end

      def webinar_registrant_add(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id, :email, :first_name, :last_name)
              .permit(%i[occurrence_ids address city country zip state phone
                         industry org job_title purchasing_time_frame role_in_purchase_process
                         no_of_employees comments custom_questions])
        Utils.parse_response self.class.post("/webinars/#{params[:id]}/registrants", body: params.except(:id, :occurrence_ids).to_json, query: params.slice(:occurrence_ids), headers: request_headers)
      end

      def webinar_registrants_status_update(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:id, :action)
              .permit(:occurrence_id, registrants: [])
        Utils.parse_response self.class.put("/webinars/#{params[:id]}/registrants/status", body: params.except(:id, :occurrence_ids).to_json, query: params.slice(:occurrence_ids), headers: request_headers)
      end

      def past_webinar_list(*args)
        # TODO: implement past_webinars_list
        # options = Utils.extract_options!(args)
        raise Zoom::NotImplemented, 'past_webinars_list is not yet implemented'
      end
    end
  end
end
