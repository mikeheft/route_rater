# frozen_string_literal: true

RSpec.describe Rides::Commands::GetRoutesData do
  let(:rides) do
    [
      double(:ride, origin_place_id: "origin1", destination_place_id: "dest1"),
      double(:ride, origin_place_id: "origin2", destination_place_id: "dest2")
    ]
  end

  it "gets data for an address" do
    VCR.use_cassette("first_ride_directions") do
      data = described_class.call(rides:)

      expect(data.length).to eq(2)
      expect(data.all? { _1.distance_in_meters == 3105 && _1.duration == "577s" })
    end
  end

  describe "caching via #call" do
    # fake redis
    let(:redis) { Redis.new }
    let(:body) { described_class.new.send(:build_request_body, rides) }
    let(:cache_key) { described_class.new.send(:encrypt!, body) }

    before { redis.flushall }

    it "does not use cached response on first call" do
      expect(redis.exists(cache_key).positive?).to be_falsey

      # Use VCR to mock API response for the first call
      VCR.use_cassette("first_ride_directions") do
        get_routes_data = described_class.new

        expect(get_routes_data).to_not receive(:get_cached_response)

        # Call the method under test
        get_routes_data.call(rides:)
      end
    end

    it "uses cached response on subsequent calls" do
      VCR.use_cassette("first_ride_directions") do
        get_routes_data = described_class.new

        # First call should not invoke connection since it should use cached response
        expect(get_routes_data).to receive(:connection).and_call_original
        get_routes_data.call(rides:)

        # Subsequent call should also not invoke connection
        expect(get_routes_data).not_to receive(:connection)
        expect(get_routes_data).to receive(:get_cached_response).and_call_original
        get_routes_data.call(rides:)
      end
    end
  end
end
