module Zoom
  module Constants
    module Meeting
      REGISTRATION_TYPES = {
        "Attendees register once and can attend any of the occurrences" => 1, # default
        "Attendees need to register for each occurrence to attend" => 2,
        "Attendees register once and can choose one or more occurrences to attend" => 3
      }.freeze
    end
  end
end
