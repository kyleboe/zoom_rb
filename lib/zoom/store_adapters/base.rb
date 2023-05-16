# frozen_string_literal: true

module Zoom
  module StoreAdapters
    class Base
      def initialize(key, config)
        @key = key
        @config = config
      end

      def access_token
        raise NotImplementedError
      end

      def refresh_token
        raise NotImplementedError
      end

      def expires_in
        raise NotImplementedError
      end

      def expires_at
        raise NotImplementedError
      end

      def access_token=(_value)
        raise NotImplementedError
      end

      def refresh_token=(_value)
        raise NotImplementedError
      end

      def expires_in=(_value)
        raise NotImplementedError
      end

      def expires_at=(_value)
        raise NotImplementedError
      end

      private

      attr_reader :key, :config
    end
  end
end
