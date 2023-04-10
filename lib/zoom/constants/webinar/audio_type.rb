module Zoom
  module Constants
    module Webinar
      AUDIO_TYPE = {
        "Both Telephony and VoIP" => "both", # default
        "Telephony only" => "telephony",
        "VoIP only" => "voip"
      }.freeze
    end
  end
end
