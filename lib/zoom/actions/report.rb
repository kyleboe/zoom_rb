# frozen_string_literal: true

module Zoom
  module Actions
    module Report
      extend Zoom::Actions

      get 'daily_report', '/report/daily',
        permit: %i[year month]

      get 'meeting_details_report', '/report/meetings/:id'

      get 'meeting_participants_report', '/report/meetings/:id/participants',
        permit: %i[page_size next_page_token]

      get 'webinar_participants_report', '/report/webinars/:id/participants',
        permit: %i[page_size next_page_token]

      get 'webinar_details_report', '/report/webinars/:webinar_id'
    end
  end
end
