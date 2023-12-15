# frozen_string_literal: true

module Zoom
  module Actions
    module Meeting
      extend Zoom::Actions

      # List all the scheduled meetings on Zoom.
      get 'meeting_list', '/users/:user_id/meetings',
        require: [:user_id],
        permit: %i[type page_size next_page_token page_number]

      # Create a meeting on Zoom, return the created meeting URL
      post 'meeting_create', '/users/:user_id/meetings',
        require: [:user_id],
        permit: %i[
          topic type start_time duration schedule_for timezone password default_password agenda tracking_fields
          recurrence settings template_id
        ]

      # Get a meeting on Zoom via meeting ID, return the meeting info.
      get 'meeting_get', '/meetings/:meeting_id/',
        require: [:meeting_id],
        permit: %i[occurrence_id show_previous_occurrences]

      # Update meeting info on Zoom via meeting ID.
      patch 'meeting_update', '/meetings/:meeting_id',
        require: [:meeting_id],
        permit: %i[topic timezone password option_audio option_auto_record_type]

      # Delete a meeting on Zoom, return the deleted meeting ID.
      delete 'meeting_delete', '/meetings/:meeting_id',
        require: [:meeting_id]

      # Update a meeting's status
      put 'meeting_update_status', '/meetings/:meeting_id/status',
        require: [:meeting_id],
        permit: :action

      # Update registrant's status
      put 'meeting_registrants_status_update', '/meetings/:meeting_id/registrants/status',
        require: [:meeting_id, :action],
        permit: [:occurrence_id, {registrants: []}]

      # Register for a meeting.
      post 'meeting_add_registrant', '/meetings/:meeting_id/registrants',
        require: [:meeting_id, :email, :first_name],
        permit: %i[
          last_name address city country zip state phone industry org job_title
          purchasing_time_frame role_in_purchase_process no_of_employees comments custom_questions
          language occurrence_ids auto_approve
        ]

      # Register up to 30 registrants at once for a meeting that requires registration.
      post 'batch_registrants', '/meetings/:meeting_id/batch_registrants',
        require: [:meeting_id],
        permit: %i[registrants auto_approve registrants_confirmation_email]

      # Register for a meeting.
      patch 'meeting_registrant_questions', '/meeting/:meeting_id/registrants/questions',
        require: [:meeting_id]

      # List users that have registered for a meeting.
      get 'meeting_list_registrants', '/meetings/:meeting_id/registrants',
        require: [:meeting_id],
        permit: %i[occurrence_id status page_size next_page_token]

      # Delete a meeting registrant
      delete 'meeting_delete_registrant', '/meetings/:meeting_id/registrants/:registrant_id',
        require: [:meeting_id, :registrant_id]
      
      # Retrieve a meeting registrant
      get 'meeting_get_registrant', '/meetings/:meeting_id/registrants/:registrant_id',
        require: [:meeting_id, :registrant_id]

      # Retrieve ended meeting details
      get 'past_meeting_details', '/past_meetings/:meeting_id',
        require: [:meeting_id]

      # Retrieve past meeting instances
      get 'past_meeting_instances', '/past_meetings/:meeting_id/instances',
        require: [:meeting_id]

      # Retrieve ended meeting participants
      get 'past_meeting_participants', '/past_meetings/:meeting_id/participants',
        require: [:meeting_id],
        permit: %i[page_size next_page_token include_fields]

      patch 'livestream', '/meetings/:meeting_id/livestream',
        require: [:meeting_id, :stream_url, :stream_key],
        permit: :page_url

      # Get a meeting on Zoom via meeting ID, return the meeting info.
      get 'meeting_invitation', '/meetings/:meeting_id/invitation',
        require: [:meeting_id]
    end
  end
end
