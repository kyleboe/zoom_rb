# frozen_string_literal: true

module Zoom
  module StoreAdapters
    class Memory < Base
      attr_accessor(*::Zoom::TokenStore::PARAMS)
    end
  end
end
