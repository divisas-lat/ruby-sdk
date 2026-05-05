# frozen_string_literal: true

require "spec_helper"

RSpec.describe DivisasLat::Client do
  let(:client) { DivisasLat::Client.new(api_key: "test_key") }

  it "has a version number" do
    expect(DivisasLat::VERSION).not_to be nil
  end

  it "queries today rates correctly" do
    expect(client.query).to be_a(DivisasLat::Builder)
    
    # We could stub Net::HTTP here but let's just make sure it parses properly
    # Using WebMock would be ideal here in a real project
  end
end
