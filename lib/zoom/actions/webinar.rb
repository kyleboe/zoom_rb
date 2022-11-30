# frozen_string_literal: true

module Zoom
  module Actions
    module Webinar
      extend Zoom::Actions

      RECURRENCE_KEYS = %i[type repeat_interval weekly_days monthly_day monthly_week
                            monthly_week_day end_times end_date_time].freeze
      SETTINGS_KEYS = [
                        %i[
                          host_video panelists_video practice_session hd_video approval_type
                          registration_type audio auto_recording enforce_login
                          enforce_login_domains alternative_hosts close_registration
                          show_share_button allow_multiple_devices on_demand
                          request_permission_to_unmute_participants global_dial_in_countries
                          contact_name contact_email registrants_restrict_number
                          post_webinar_survey survey_url registrants_email_notification
                          meeting_authentication authentication_option
                          authentication_domains registrants_confirmation_email
                        ],
                        {
                            language_interpretation: [
                            :enable,
                            interpreters: %i[email languages]
                          ],
                          question_and_answer: %i[
                            allow_anonymous_questions answer_questions attendees_can_comment
                            attendees_can_upvote enable
                          ],
                          attendees_and_panelists_reminder_email_notification: %i[enable type],
                          follow_up_absentees_email_notification: %i[enable type],
                          follow_up_attendees_email_notification: %i[enable type]
                        }
                      ].freeze

      get 'webinar_list', '/users/:host_id/webinars',
        permit: %i[page_size next_page_token]

      # TODO: process recurrence keys based on constants
      # TODO: process settings keys based on constants
      post 'webinar_create', '/users/:host_id/webinars',
        permit: [
          :topic, :type, :start_time, :duration, :timezone, :password, :agenda,
          { recurrence: RECURRENCE_KEYS, settings: SETTINGS_KEYS }
        ]

      get 'webinar_get', '/webinars/:id'

      patch 'webinar_update', '/webinars/:id',
        permit: [
          :topic, :type, :start_time, :duration, :timezone, :password, :agenda,
          { recurrence: RECURRENCE_KEYS, settings: SETTINGS_KEYS }
        ]

      delete 'webinar_delete', '/webinars/:id',
        permit: :occurrence_id

      get 'webinar_registrants_list', '/webinars/:id/registrants',
        permit: %i[occurrence_id status page_size page_number]

      post 'webinar_registrant_add', '/webinars/:id/registrants',
        require: %i[email first_name last_name],
        permit: %i[
          occurrence_ids address city country zip state phone industry org job_title
          purchasing_time_frame role_in_purchase_process no_of_employees comments custom_questions
        ]

      put 'webinar_registrants_status_update', '/webinars/:id/registrants/status',
        require: :action,
        permit: [ :occurrence_id, registrants: [] ]

      get 'past_webinar_list', '/past_webinars/:id/instances'

      get 'webinar_registrant_get', '/webinars/:webinar_id/registrants/:id',
        permit: :occurrence_id

      get 'webinar_polls_list', '/webinars/:webinar_id/polls'

      get 'webinar_poll_get', '/webinars/:webinar_id/polls/:poll_id'

      get 'webinar_panelist_list', '/webinars/:webinar_id/panelists'

      post 'webinar_panelist_add', '/webinars/:webinar_id/panelists',
        require: :panelists,
        permit: [ panelists: [] ]

      delete 'webinar_panelist_delete', '/webinars/:webinar_id/panelists/:panelist_id'

      delete 'webinar_panelists_delete_all', '/webinars/:webinar_id/panelists'

      get 'past_webinars_absentees', '/past_webinars/:webinar_uuid/absentees',
        permit: %i[occurrence_id page_size next_page_token]
    end
  end
end
