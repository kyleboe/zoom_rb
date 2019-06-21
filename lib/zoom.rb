# frozen_string_literal: true

$:.unshift File.dirname(__FILE__)

require 'zoom/version'
require 'zoom/constants'
require 'zoom/params'
require 'zoom/utils'
require 'zoom/actions/account'
require 'zoom/actions/cloud_recording'
require 'zoom/actions/group'
require 'zoom/actions/m323_device'
require 'zoom/actions/meeting'
require 'zoom/actions/metrics'
require 'zoom/actions/recording'
require 'zoom/actions/report'
require 'zoom/actions/user'
require 'zoom/actions/webinar'
require 'zoom/actions/im/chat'
require 'zoom/actions/im/group'
require 'zoom/client'
require 'zoom/error'

module Zoom
  class << self
    attr_accessor :configuration

    def new
      @configuration ||= Configuration.new
      Zoom::Clients::JWT.new(
        api_key: @configuration.api_key,
        api_secret: @configuration.api_secret,
        timeout: @configuration.timeout
      )
    end

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end
  end

  class Configuration
    attr_accessor :api_key, :api_secret, :timeout, :access_token

    def initialize
      @api_key = @api_secret = 'xxx'
      @access_token = nil
      @timeout = 15
    end
  end
end
