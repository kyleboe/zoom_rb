# frozen_string_literal: true

module Zoom
  module Actions
    module Meeting

      def meeting_invitation(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.get("/meetings/#{options[:meeting_id]}/invitation", headers: request_headers)
      end

      # List all the scheduled meetings on Zoom.
      def meeting_list(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[user_id])
        Utils.parse_response self.class.get("/users/#{options[:user_id]}/meetings", query: options.except(:user_id), headers: request_headers)
      end

      # Create a meeting on Zoom, return the created meeting URL
      def meeting_create(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[user_id])
        Utils.process_datetime_params!(:start_time, options)
        Utils.parse_response self.class.post("/users/#{options[:user_id]}/meetings", body: options.except(:user_id).to_json, headers: request_headers)
      end

      # Get a meeting on Zoom via meeting ID, return the meeting info.
      def meeting_get(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.get("/meetings/#{options[:meeting_id]}", query: options.except(:meeting_id), headers: request_headers)
      end

      # Update meeting info on Zoom via meeting ID.
      def meeting_update(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.process_datetime_params!(:start_time, options)
        # TODO Handle `topic` attr, Max of 300 characters.
        # TODO Handle `timezone` attr, refer to the id value in timezone list JSON file. like "America/Los_Angeles"
        # TODO Verify `password` attr, may only contain the following characters: a-z A-Z 0-9 @ - _
        # TODO Handle `option_audio` attr, Can be "both", "telephony", "voip".
        # TODO Handle `option_auto_record_type`, Can be "local", “cloud” or "none".
        Utils.parse_response self.class.patch("/meetings/#{options[:meeting_id]}", body: options.except(:meeting_id).to_json, headers: request_headers)
      end

      # Delete a meeting on Zoom, return the deleted meeting ID.
      def meeting_delete(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.delete("/meetings/#{options[:meeting_id]}", query: options.except(:meeting_id), headers: request_headers)
      end

      # Update a meeting's status
      def meeting_update_status(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.put("/meetings/#{options[:meeting_id]}/status", body: options.except(:meeting_id).to_json, headers: request_headers)
      end

      # End a meeting on Zoom, return the deleted meeting ID.
      def meeting_end(*args)
        options = Utils.extract_options!(args)
        meeting_update_status(options.merge(action: 'end'))
      end

      # Lists the live meetings on Zoom.
      def meeting_live(*args)
        options = Utils.extract_options!(args)
        meeting_list(options.merge(type: 'live'))
      end

      def meeting_bulk_register(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id registrants])

        registrants = options[:registrants].map do |data|
          registrant = Zoom::Params.new(data)
          registrant.require(%i[email first_name last_name])
          registrant
        end

        Utils.parse_response self.class.post("/meetings/#{options[:meeting_id]}/batch_registrants", query: options.slice(:occurrence_ids), body: registrants.to_json, headers: request_headers)
      end

      # Register for a meeting.
      def meeting_register(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id email first_name last_name])
        Utils.parse_response self.class.post("/meetings/#{options[:meeting_id]}/registrants", query: options.slice(:occurrence_ids), body: options.except(:meeting_id, :occurence_ids).to_json, headers: request_headers)
      end

      def list_meeting_registrants(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.get("/meetings/#{options[:meeting_id]}/registrants", body: options.except(:meeting_id).to_json, headers: request_headers)
      end

      def update_meeting_registrant_status(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[action registrants])
        Utils.parse_response self.class.put("/meetings/#{options[:meeting_id]}/registrants/status", body: options.except(:meeting_id).to_json, headers: request_headers)
      end

      # Register for a meeting.
      def meeting_registrant_questions(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id])
        Utils.parse_response self.class.patch("/meetings/#{options[:meeting_id]}/registrants/questions", body: options.except(:meeting_id).to_json, headers: request_headers)
      end

      # Retrieve ended meeting details
      def past_meeting_details(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_uuid])
        Utils.parse_response self.class.get("/past_meetings/#{options[:meeting_uuid]}", headers: request_headers)
      end

      # Retrieve ended meeting participants
      def past_meeting_participants(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_uuid])
        Utils.parse_response self.class.get("/past_meetings/#{options[:meeting_uuid]}/participants", headers: request_headers)
      end

      def livestream(*args)
        options = Zoom::Params.new(Utils.extract_options!(args))
        options.require(%i[meeting_id stream_url stream_key]).permit(%i[page_url])
        Utils.parse_response self.class.patch("/meetings/#{options[:meeting_id]}/livestream", body: options.except(:meeting_id), headers: request_headers)
      end

    end
  end
end
