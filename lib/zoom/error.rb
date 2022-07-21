# frozen_string_literal: true

module Zoom
  class Error < StandardError
    attr_reader :error_hash

    def initialize(msg, error_hash={})
      @error_hash = error_hash
      super(msg)
    end
  end
  class GatewayTimeout < StandardError; end
  class NotImplemented < StandardError; end
  class ParameterMissing < StandardError; end
  class ParameterNotPermitted < StandardError; end
  class ParameterValueNotPermitted < StandardError; end
  class AuthenticationError < StandardError; end
  class BadRequest < StandardError; end
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end
  class NotFound < StandardError; end
  class Conflict < StandardError; end
  class TooManyRequests < StandardError; end
  class InternalServerError < StandardError; end
end
