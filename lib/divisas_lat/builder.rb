# frozen_string_literal: true

module DivisasLat
  class Builder
    def initialize(client)
      @client = client
      @country = nil
      @currency = nil
    end

    def for_country(country)
      @country = country
      self
    end

    def with_currency(currency)
      @currency = currency
      self
    end

    def get_today
      endpoint = "/#{country_code}/rates"
      endpoint += "/#{@currency}" if @currency
      @client.send(:request, endpoint, {}, DivisasLat::Models::TodayRatesResponse)
    end

    def convert(to:, amount:)
      endpoint = "/#{country_code}/rates/convert"
      query = { "to" => to, "amount" => amount }
      query["from"] = @currency if @currency

      @client.send(:request, endpoint, query, DivisasLat::Models::ConversionResponse)
    end

    def get_history(from: nil, to: nil)
      raise DivisasLat::Error, "Currency is required for historical data" unless @currency

      endpoint = "/#{country_code}/rates/history"
      query = { "currency" => @currency }
      query["from"] = from if from
      query["to"] = to if to

      @client.send(:request, endpoint, query, DivisasLat::Models::HistoricalRateResponse)
    end

    def get_stats(period: "30d")
      endpoint = "/#{country_code}/rates/stats"
      query = { "period" => period }
      query["currency"] = @currency if @currency

      @client.send(:request, endpoint, query, DivisasLat::Models::StatsResponse)
    end

    def get_forecast(days: 7)
      endpoint = "/#{country_code}/rates/forecast"
      query = { "days" => days }
      query["currency"] = @currency if @currency

      @client.send(:request, endpoint, query, DivisasLat::Models::ForecastResponse)
    end

    def get_percentile(period: "1y")
      endpoint = "/#{country_code}/rates/percentile"
      query = { "period" => period }
      query["currency"] = @currency if @currency

      @client.send(:request, endpoint, query, DivisasLat::Models::PercentileResponse)
    end

    private

    def country_code
      raise DivisasLat::Error, "Country is required. Call for_country() first." unless @country
      @country
    end
  end
end
