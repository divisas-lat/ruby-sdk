# frozen_string_literal: true

module DivisasLat
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class RateLimitError < Error; end
  class APIError < Error
    attr_reader :status_code

    def initialize(message, status_code = nil)
      super(message)
      @status_code = status_code
    end
  end
end
