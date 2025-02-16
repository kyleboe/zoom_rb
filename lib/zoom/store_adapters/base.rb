# frozen_string_literal: true

module Zoom
  module StoreAdapters
    class Base
      def initialize(config)
        @config = config
      end

      ::Zoom::TokenStore::PARAMS.each do |method|
        define_method method do
          raise NotImplementedError
        end

        define_method "#{method}=" do |data|
          raise NotImplementedError
        end
      end

      private

      attr_reader :key, :config
    end
  end
end
