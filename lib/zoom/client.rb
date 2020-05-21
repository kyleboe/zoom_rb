# frozen_string_literal: true

require 'httparty'

module Zoom
  class Client
    include HTTParty
    include Actions::Account
    include Actions::Data
    include Actions::Group
    include Actions::M323Device
    include Actions::User
    include Actions::Meeting
    include Actions::Metrics
    include Actions::Phone
    include Actions::Webinar
    include Actions::Report
    include Actions::Recording
    include Actions::IM::Chat
    include Actions::IM::Group

    base_uri 'https://api.zoom.us/v2'
    headers 'Accept' => 'application/json'
    headers 'Content-Type' => 'application/json'

    def request_headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{access_token}"
      }
    end
  end
end

require 'zoom/clients/jwt'
require 'zoom/clients/oauth'
