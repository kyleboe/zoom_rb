module Zoom
  module Constants
    module Webinar
      REGISTRATION_TYPES = {
        1 => "Attendees register once and can attend any of the occurrences", # default
        2 => "Attendees need to register for each occurrence to attend",
        3 => "Attendees register once and can choose one or more occurrences to attend"
      }.freeze
    end
  end
end
