# frozen_string_literal: true

require_relative "account/options/pay_modes"
require_relative "account/settings/permitted_settings"
require_relative "meeting/approval_types"
require_relative "meeting/audio_type"
require_relative "meeting/auto_recording"
require_relative "meeting/registration_types"
require_relative "meeting/types"
require_relative "recurrence/monthly_weeks"
require_relative "recurrence/types"
require_relative "recurrence/weekly_days"
require_relative "user/create_types"
require_relative "user/types"
require_relative "webinar/approval_types"
require_relative "webinar/audio_type"
require_relative "webinar/auto_recording"
require_relative "webinar/registration_types"
require_relative "webinar/types"

module Zoom
  module Constants
    IM_GROUP_TYPES = {
      "normal" => "Only members can see the group automatically. Other people can search members in the group.", # default
      "shared" => "All people in the account can see the group and members automatically",
      "restricted" => "Nobody can see the group or search members except the members in the group"
    }.freeze

    REGISTRANT_STATUS_ACTIONS = {
      "Approve registrant" => "approve",
      "Cancel registrant" => "cancel",
      "Deny registrant" => "deny"
    }.freeze # no default
  end
end
