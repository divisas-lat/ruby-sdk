# Divisas.lat Ruby SDK

Official Ruby SDK for [Divisas.lat](https://divisas.lat) - The easiest way to get official exchange rates from Central Banks across Latin America.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'divisas-ruby-sdk'
```

And then execute:
```bash
bundle install
```

Or install it yourself as:
```bash
gem install divisas-ruby-sdk
```

## Setup

Set your API key as an environment variable:
```bash
export DIVISAS_API_KEY="your_api_key_here"
```

## Usage

```ruby
require 'divisas_lat'

client = DivisasLat::Client.new

# Get all supported countries
countries = client.get_countries

# Query today's exchange rates
today_rates = client.query
                    .for_country(DivisasLat::Enums::Country::GUATEMALA)
                    .get_today

puts today_rates.rate.buy
```

### Thread-safe Caching Built-in
The SDK includes an automatic memory cache (default TTL is 1 hour) to avoid hitting the API rate limits on consecutive requests.

## Documentation
Refer to the official API docs at [docs.divisas.lat](https://docs.divisas.lat) for all available endpoints (History, Conversions, Forecasts, Stats).

## Publishing
See [PUBLISH_INSTRUCTIONS.md](PUBLISH_INSTRUCTIONS.md).
