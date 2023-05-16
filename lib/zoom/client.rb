# frozen_string_literal: true

require 'httparty'

module Zoom
  class Client
    include HTTParty
    include Actions::Account
    include Actions::Billing
    include Actions::Dashboard
    include Actions::Groups
    include Actions::M323Device
    include Actions::Meeting
    include Actions::Phone
    include Actions::Recording
    include Actions::Report
    include Actions::Roles
    include Actions::SipAudio
    include Actions::Token
    include Actions::User
    include Actions::Webinar
    include Actions::IM::Chat
    include Actions::IM::Group

    base_uri 'https://api.zoom.us/v2'
    headers 'Accept' => 'application/json'
    headers 'Content-Type' => 'application/json'

    def headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
      }
    end

    def oauth_request_headers
      {
        'Authorization' => "Basic #{auth_token}",
        'Accept' => 'application/json',
        'Content-Type' => 'application/x-www-form-urlencoded',
      }
    end

    def bearer_authorization_header
      {
        'Authorization' => "Bearer #{access_token}"
      }
    end

    def request_headers
      bearer_authorization_header.merge(headers)
    end

    def auth_token
      Base64.encode64("#{Zoom.configuration.api_key}:#{Zoom.configuration.api_secret}").delete("\n")
    end

    ::Zoom::TokenStore::PARAMS.each do |method|
      define_method method do
        token_store.public_send(method)
      end
    end

    private

    attr_reader :store_key

    def extract_params(config)
      extract_store_key(config)

      config.each do |k, v|
        if ::Zoom::TokenStore::PARAMS.include?(k.to_sym)
          token_store.public_send("#{k}=", v)
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end

    def extract_store_key(config)
      @store_key = config.delete(:store_key) || begin
        require 'securerandom'
        SecureRandom.uuid
      end
    end

    def token_store
      @token_store ||= ::Zoom::TokenStore.build(store_key, Zoom.configuration&.token_store)
    end
  end
end

require 'zoom/clients/jwt'
require 'zoom/clients/oauth'
require 'zoom/clients/server_to_server_oauth'
