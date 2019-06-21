module Zoom
  module Actions
    module CloudRecording
      #
      # Delete one meeting recording file
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingslist
      #
      # GET /users/{userId}/recordings
      def cloud_recording_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:user_id).permit(:page_size, :next_page_token, :mc, :trash, :from, :to)
        Utils.parse_response self.class.get("/users/#{params[:user_id]}/recordings", query: params, headers: request_headers)
      end

      #
      # Retrieve all the recordings from a meeting.
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingget
      #
      # GET /meetings/{meetingId}/recordings
      def meeting_recordings_list(*args)
        params = Zoom::Params.new(Utils.extract_options!(args))
        params.require(:meeting_id)
        Utils.parse_response self.class.get("/meetings/#{params[:meeting_id]}/recordings", query: params, headers: request_headers)
      end

      #
      # Delete a meeting’s recordings.
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingdelete
      #
      # DELETE /meetings/{meetingId}/recordings
      def meeting_recordings_delete(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_delete is not yet implemented'
      end

      # Delete one meeting recording file
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingdeleteone
      #
      # DELETE /meetings/{meetingId}/recordings/{recordingId}
      def meeting_recording_delete(*args)
        raise Zoom::NotImplemented, 'meeting_recording_delete is not yet implemented'
      end

      #
      # Recover a meeting’s recordings.
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingstatusupdate
      #
      # PUT /meetings/{meetingId}/recordings/status
      def meeting_recordings_recover(*args)
        raise Zoom::NotImplemented, 'meeting_recording_delete is not yet implemented'
      end

      #
      # Recover a single recording.
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingstatusupdateone
      #
      # PUT /meetings/{meetingId}/recordings/{recordingId}/status
      def meeting_recording_recover(*args)
        raise Zoom::NotImplemented, 'meeting_recording_recover is not yet implemented'
      end

      #
      # Retrieve a meeting recording’s settings
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingsettingupdate
      #
      # GET /meetings/{meetingId}/recordings/settings
      def meeting_recordings_settings_get(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_settings is not yet implemented'
      end

      #
      # Update a meeting recording’s settings
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingsettingsupdate
      #
      # PATCH /meetings/{meetingId}/recordings/settings
      def meeting_recordings_settings_update(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_settings_update is not yet implemented'
      end

      #
      # List registrants of a meeting recording
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/meetingrecordingregistrants
      #
      # GET /meetings/{meetingId}/recordings/registrants
      def meeting_recordings_registrant_list(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_registrants_list is not yet implemented'
      end

      #
      # Register a participant for a meeting recording
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/meetingrecordingregistrantcreate
      #
      # POST /meetings/{meetingId}/recordings/registrants
      def meeting_recordings_registrant_create(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_registrant_create is not yet implemented'
      end

      #
      # Update a meeting recording registrant’s status
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/meetingrecordingregistrantstatus
      #
      # PUT /meetings/{meetingId}/recordings/registrants/status
      def meeting_recordings_registrant_update(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_registrant_update is not yet implemented'
      end

      #
      # Retrieve a recording’s registrant questions
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingregistrantsquestionsget
      #
      # GET /meetings/{meetingId}/recordings/registrants/questions
      def meeting_recordings_registrant_questions_get(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_registrant_questions_get is not yet implemented'
      end

      #
      # Update a recording’s registrant questions
      #
      # https://marketplace.zoom.us/docs/api-reference/zoom-api/cloud-recording/recordingregistrantquestionupdate
      #
      # PATCH /meetings/{meetingId}/recordings/registrants/questions
      def meeting_recordings_registrant_questions_update(*args)
        raise Zoom::NotImplemented, 'meeting_recordings_registrant_questions_update is not yet implemented'
      end

    end
  end
end

