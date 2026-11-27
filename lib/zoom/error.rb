# frozen_string_literal: true

module Zoom
  class Error < StandardError
    attr_reader :code, :errors, :headers

    def initialize(message, code = nil, errors = nil, headers = nil)
      @code = code
      @errors = errors
      @headers = headers || {}
      super(message)
    end
  end
  class GatewayTimeout < Error; end
  class NotImplemented < Error; end
  class ParameterMissing < Error; end
  class ParameterNotPermitted < Error; end
  class ParameterValueNotPermitted < Error; end
  class BadRequest < Error; end
  class Unauthorized < Error; end
  class Forbidden < Error; end
  class NotFound < Error; end
  class Conflict < Error; end
  class TooManyRequests < Error; end
  class InternalServerError < Error; end
end
