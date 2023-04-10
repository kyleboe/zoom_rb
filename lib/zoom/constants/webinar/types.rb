module Zoom
  module Constants
    module Webinar
      TYPES = {
        5 => "Webinar", # default
        6 => "Recurring Webinar with no fixed time",
        9 => "Recurring Webinar with fixed time"
      }.freeze
    end
  end
end
