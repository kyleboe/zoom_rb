# frozen_string_literal: true

module Zoom
  module Actions
    module Meeting
      extend Zoom::Actions

      # List all the scheduled meetings on Zoom.
      get 'meeting_list', '/users/:user_id/meetings',
        permit: %i[type page_size next_page_token page_number]

      # Create a meeting on Zoom, return the created meeting URL
      post 'meeting_create', '/users/:user_id/meetings',
        permit: %i[
          topic type start_time duration schedule_for timezone password agenda tracking_fields
          recurrence settings template_id
        ]

      # Get a meeting on Zoom via meeting ID, return the meeting info.
      get 'meeting_get', '/meetings/:meeting_id/',
        permit: %i[occurrence_id show_previous_occurrences]

      # Update meeting info on Zoom via meeting ID.
      # TODO Handle `topic` attr, Max of 300 characters.
      # TODO Handle `timezone` attr, refer to the id value in timezone list JSON file. like "America/Los_Angeles"
      # TODO Verify `password` attr, may only contain the following characters: a-z A-Z 0-9 @ - _
      # TODO Handle `option_audio` attr, Can be "both", "telephony", "voip".
      # TODO Handle `option_auto_record_type`, Can be "local", “cloud” or "none".
      patch 'meeting_update', '/meetings/:meeting_id'

      # Delete a meeting on Zoom, return the deleted meeting ID.
      delete 'meeting_delete', '/meetings/:meeting_id'

      # Update a meeting's status
      put 'meeting_update_status', '/meetings/:meeting_id/status',
        permit: :action

      # Update registrant's status
      put 'meeting_registrants_status_update', '/meetings/:meeting_id/registrants/status',
          require: :action,
          permit: [ :occurrence_id, registrants: [] ]

      # Register for a meeting.
      post 'meeting_add_registrant', '/meetings/:meeting_id/registrants',
        require: %i[email first_name],
        permit: %i[
          last_name address city country zip state phone industry org job_title
          purchasing_time_frame role_in_purchase_process no_of_employees comments custom_questions
          language occurrence_ids auto_approve
        ]

      # Register up to 30 registrants at once for a meeting that requires registration.
      post 'batch_registrants', '/meetings/:meeting_id/batch_registrants',
        permit: %i[registrants auto_approve registrants_confirmation_email]

      # Register for a meeting.
      patch 'meeting_registrant_questions', '/meeting/:meeting_id/registrants/questions'

      # List users that have registered for a meeting.
      get 'list_meeting_registrants', '/meetings/:meeting_id/registrants',
        permit: %i[occurrence_id status page_size next_page_token]

      # Retrieve ended meeting details
      get 'past_meeting_details', '/past_meetings/:meeting_uuid'

      # Retrieve past meeting instances
      get 'past_meeting_instances', '/past_meetings/:meeting_id/instances'

      # Retrieve ended meeting participants
      get 'past_meeting_participants', '/past_meetings/:meeting_uuid/participants'

      patch 'livestream', '/meetings/:meeting_id/livestream',
        require: %i[stream_url stream_key],
        permit: :page_url

      # Get a meeting on Zoom via meeting ID, return the meeting info.
      get 'meeting_invitation', '/meetings/:meeting_id/invitation'
    end
  end
end
