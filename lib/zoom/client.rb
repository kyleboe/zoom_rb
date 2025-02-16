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
        auth if need_refresh?

        token_store.public_send(method)
      end
    end

    private

    attr_reader :auto_refresh_token, :token_store_config

    def extract_params(config)
      config.each do |k, v|
        if ::Zoom::TokenStore::PARAMS.include?(k.to_sym)
          token_store.public_send("#{k}=", v)
        else
          instance_variable_set("@#{k}", v)
        end
      end
    end

    def token_store
      @token_store ||= ::Zoom::TokenStore.build(token_store_config)
    end

    def need_refresh?
      return false unless auto_refresh_token
      return true if token_store.access_token.nil? || token_store.access_token.empty?
      return false if token_store.expires_at.nil?

      token_store.expires_at < Time.now.to_i
    end
  end
end

require 'zoom/clients/jwt'
require 'zoom/clients/oauth'
require 'zoom/clients/server_to_server_oauth'
