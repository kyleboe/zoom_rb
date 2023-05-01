module Zoom
  module Constants
    module Meeting
      TYPES = {
        1 => "Instant Meeting",
        2 => "Scheduled Meeting", # default
        3 => "Recurring Meeting with no fixed time",
        8 => "Recurring Meeting with fixed time"
      }.freeze
    end
  end
end
