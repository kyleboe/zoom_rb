# frozen_string_literal: true

module Zoom
  module Actions
    module Dashboard
      extend Zoom::Actions

      get 'dashboard_crc', '/metrics/crc',
        require: %i[from to]

      get 'dashboard_meetings', '/metrics/meetings',
        require: %i[from to],
        permit: %i[next_page_token page_size type]

      get 'dashboard_meeting_details', '/metrics/meetings/:meeting_id',
        permit: :type

      get 'dashboard_meeting_participants', '/metrics/meetings/:meeting_id/participants',
        permit: %i[next_page_token page_size type]
    end
  end
end
