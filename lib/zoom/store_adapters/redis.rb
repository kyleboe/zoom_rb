# frozen_string_literal: true

module Zoom
  module StoreAdapters
    class Redis < Base
      ::Zoom::TokenStore::PARAMS.each do |method|
        define_method method do
          val = storage.get key(method)

          if %i[expires_in expires_at].include?(method)
            val.to_i
          else
            val
          end
        end

        define_method "#{method}=" do |data|
          storage.set key(method), data
        end
      end

      private

      def storage
        @storage ||= build_storage
      end

      def build_storage
        ::Redis.new(config)
      rescue NameError => e
        msg = 'Could not load the \'redis\' gem, please add it to your gemfile and require \'redis\' or ' \
              'configure a different adapter '
        raise e.class, msg, e.backtrace
      end

      def key(name)
        "zoom_rb:#{id}:#{name}"
      end

      def id
        @id ||= build_id
      end

      def build_id
        if config[:key].nil?
          require 'securerandom'
          SecureRandom.uuid
        elsif config[:key].respond_to?(:call)
          config[:key].call
        else
          config[:key]
        end
      end
    end
  end
end
