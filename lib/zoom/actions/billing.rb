# frozen_string_literal: true

module Zoom
  module Actions
    module Billing
      extend Zoom::Actions

      get 'billing_get', '/accounts/:account_id/billing'

      patch 'billing_update', '/accounts/:account_id/billing',
        permit:  %i[first_name last_name email phone_number address apt city state zip country]

      get 'billing_plans_list', '/accounts/:account_id/plans'

      get 'billing_plans_usage', '/accounts/:account_id/plans/usage'

      post 'billing_plans_subscribe', '/accounts/:account_id/plans',
        require: {
          contact: %i[first_name last_name email phone_number address city state zip country],
          plan_base: %i[type hosts]
        },
        permit: [
          :plan_recording,
          {
            contact: %i[apt],
            plan_zoom_rooms: %i[type hosts],
            plan_room_connector: %i[type hosts],
            plan_large_meeting: %i[type hosts],
            plan_zoom_events: %i[type hosts],
            plan_webinar: %i[type hosts],
            plan_audio: %i[type tollfree_countries premium_countries callout_countries ddi_numbers],
            plan_phone: {
              plan_base: %i[type callout_countries],
              plan_calling: %i[type hosts],
              plan_number: %i[type hosts]
            }
          }
        ]
    end
  end
end
