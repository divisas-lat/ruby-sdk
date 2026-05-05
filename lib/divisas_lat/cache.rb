# frozen_string_literal: true

require "monitor"

module DivisasLat
  class MemoryCache
    include MonitorMixin

    def initialize(ttl = 3600)
      super() # Initialize Monitor
      @ttl = ttl
      @store = {}
    end

    def get(key)
      synchronize do
        entry = @store[key]
        return nil unless entry

        if Time.now > entry[:expires_at]
          @store.delete(key)
          return nil
        end

        entry[:value]
      end
    end

    def set(key, value)
      synchronize do
        @store[key] = {
          value: value,
          expires_at: Time.now + @ttl
        }
      end
    end
  end
end
