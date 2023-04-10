module Zoom
  module Constants
    module Meeting
      APPROVAL_TYPES = {
        "Automatically Approve" => 0,
        "Manually Approve" => 1,
        "No Registration Required" => 2 # default
      }.freeze
    end
  end
end
