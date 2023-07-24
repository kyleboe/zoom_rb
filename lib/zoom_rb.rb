# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

require "zoom/version"
require "zoom/constants/constants"
require "zoom/params"
require "zoom/utils"
require "zoom/actions"
require "zoom/actions/account"
require "zoom/actions/billing"
require "zoom/actions/dashboard"
require "zoom/actions/groups"
require "zoom/actions/m323_device"
require "zoom/actions/meeting"
require "zoom/actions/recording"
require "zoom/actions/report"
require "zoom/actions/roles"
require "zoom/actions/token"
require "zoom/actions/user"
require "zoom/actions/webinar"
require "zoom/actions/phone"
require "zoom/actions/im/chat"
require "zoom/actions/im/group"
require "zoom/actions/sip_audio"
require "zoom/client"
require "zoom/error"

module Zoom
  class << self
    attr_accessor :configuration

    def new
      @configuration ||= Configuration.new
      Zoom::Client::ServerToServerOAuth.new(
        account_id: @configuration.account_id,
        client_id: @configuration.client_id,
        client_secret: @configuration.client_secret,
        timeout: @configuration.timeout
      )
    end

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end
  end

  class Configuration
    attr_accessor :account_id, :client_id, :client_secret, :timeout, :access_token

    def initialize
      @account_id = @client_id = @client_secret = "xxx"
      @access_token = nil
      @timeout = 15
    end
  end
end
