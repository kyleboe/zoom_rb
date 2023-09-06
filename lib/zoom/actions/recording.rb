# frozen_string_literal: true

module Zoom
  module Actions
    module Recording
      extend Zoom::Actions

      RECORDING_SETTINGS_KEYS = %i[share_recording recording_authentication
                                   authentication_option authentication_domains viewer_download password
                                   on_demand approval_type send_email_to_host show_social_share_buttons].freeze

      get 'recording_list', '/users/:user_id/recordings'

      get 'meeting_recording_get', '/meetings/:meeting_id/recordings'

      get 'meeting_recording_settings_get', '/meetings/:meeting_id/recordings/settings'

      get 'meeting_recording_analytics_summary', '/meetings/:meeting_id/recordings/analytics_summary'

      get 'meeting_recording_analytics_details', '/meetings/:meeting_id/recordings/analytics_details',
        permit: %i[page_size next_page_token from to type]

      patch 'meeting_recording_settings_update', '/meetings/:meeting_id/recordings/settings',
        permit: RECORDING_SETTINGS_KEYS

      delete 'meeting_recording_file_delete', '/meetings/:meeting_id/recordings/:recording_id'
    end
  end
end
