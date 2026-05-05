# frozen_string_literal: true

require "ostruct"

module DivisasLat
  module Models
    class BaseModel < OpenStruct
      def initialize(hash = nil)
        super(hash)
        
        # Recursively convert nested hashes to models
        if hash.is_a?(Hash)
          hash.each do |key, value|
            if value.is_a?(Hash)
              self[key] = BaseModel.new(value)
            elsif value.is_a?(Array)
              self[key] = value.map { |v| v.is_a?(Hash) ? BaseModel.new(v) : v }
            end
          end
        end
      end
    end

    class CountryResponse < BaseModel; end
    class RateData < BaseModel; end
    class TodayRatesResponse < BaseModel; end
    class ConversionResponse < BaseModel; end
    class HistoricalRateResponse < BaseModel; end
    class StatsResponse < BaseModel; end
    class ForecastResponse < BaseModel; end
    class PercentileResponse < BaseModel; end
  end
end
