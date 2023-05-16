# frozen_string_literal: true

module Zoom
  module StoreAdapters
    class Redis < Base
      ::Zoom::TokenStore::PARAMS.each do |method|
        define_method method do
          storage.get key(method)
        end
      end

      ::Zoom::TokenStore::PARAMS.map { |p| "#{p}=" }.each do |method|
        define_method method do |data|
          storage.set key(method), data
        end
      end

      private

      def storage
        @storage ||= build_storage
      end

      def build_storage
        require 'redis'

        Redis.new(url: redis_url)
      rescue LoadError => e
        msg = 'Could not load the \'redis\' gem, please add it to your gemfile or ' \
              'configure a different adapter '
        raise e.class, msg, e.backtrace
      end

      def redis_url
        if config[:url] && (config[:host] || config[:port] || config[:db])
          raise ArgumentError, 'redis_url cannot be passed along with host, port or db options'
        end

        return URI.join(config[:url], config[:db]).to_s if config[:url]

        base_url = ENV['REDIS_URL'] || "redis://#{config[:host]}:#{config[:port]}"
        URI.join(base_url, config[:db]).to_s
      end

      def key(name)
        "zoom_rb:#{key}:#{name}"
      end
    end
  end
end
