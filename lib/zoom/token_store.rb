# frozen_string_literal: true

module Zoom
  class TokenStore
    PARAMS = %i[access_token refresh_token expires_in expires_at].freeze
    DEFAULT_ADAPTER = :memory

    def self.build(key, config)
      config ||= DEFAULT_ADAPTER

      type, opts = config

      adapter = type.to_s.split('_').map(&:capitalize).join

      ::Zoom::StoreAdapters.const_get(adapter).new(key, opts)
    rescue NameError => e
      raise e.class, "Token store adapter for #{adapter} haven't been found", e.backtrace
    end
  end
end

require_relative 'store_adapters/base'
require_relative 'store_adapters/memory'
require_relative 'store_adapters/redis'