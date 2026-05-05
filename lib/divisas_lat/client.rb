# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module DivisasLat
  class Client
    attr_reader :base_url, :api_key, :cache

    def initialize(api_key: ENV["DIVISAS_API_KEY"], base_url: "https://api.divisas.lat/v1", cache_ttl: 3600)
      @api_key = api_key
      @base_url = base_url
      @cache = DivisasLat::MemoryCache.new(cache_ttl)
    end

    def query
      DivisasLat::Builder.new(self)
    end

    def get_countries
      request("/countries", {}, nil).map { |c| DivisasLat::Models::CountryResponse.new(c) }
    end

    def get_currencies(country)
      request("/#{country}/currencies", {}, nil)
    end

    private

    def request(endpoint, query_params, model_class)
      uri = URI.parse("#{@base_url}#{endpoint}")
      
      unless query_params.empty?
        uri.query = URI.encode_www_form(query_params.reject { |_, v| v.nil? })
      end

      cache_key = uri.to_s

      if cached = @cache.get(cache_key)
        return cached
      end

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = 10
      http.read_timeout = 10

      req = Net::HTTP::Get.new(uri)
      req["Accept"] = "application/json"
      req["User-Agent"] = "DivisasLat-RubySDK/#{DivisasLat::VERSION}"
      req["Authorization"] = "Bearer #{@api_key}" if @api_key

      response = http.request(req)
      body = response.body

      unless response.is_a?(Net::HTTPSuccess)
        error_msg = parse_error(body) || response.message
        
        case response.code.to_i
        when 401 then raise DivisasLat::AuthenticationError, error_msg
        when 429 then raise DivisasLat::RateLimitError, error_msg
        else raise DivisasLat::APIError.new("API Error #{response.code}: #{error_msg}", response.code.to_i)
        end
      end

      parsed = JSON.parse(body, symbolize_names: true)
      
      result = if parsed.is_a?(Array)
                 parsed
               else
                 model_class ? model_class.new(parsed) : parsed
               end

      @cache.set(cache_key, result)
      result
    rescue JSON::ParserError
      raise DivisasLat::APIError, "Failed to parse API response as JSON."
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      raise DivisasLat::APIError, "Network error: #{e.message}"
    end

    def parse_error(body)
      JSON.parse(body)["message"] rescue nil
    end
  end
end
