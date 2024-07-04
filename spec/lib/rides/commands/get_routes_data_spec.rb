# frozen_string_literal: true

RSpec.describe Rides::Commands::GetRoutesData do
  it "gets data for an address" do
    VCR.use_cassette("first_ride_directions") do
      from_address = create(
        :address, :with_out_place_id, line_1: "711 Oval Drive", city: "Fort Collins", state: "CO",
        zip_code: "80521"
      )
      to_address = create(
        :address, :with_out_place_id, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
        zip_code: "80524"
      )
      create_list(:ride, 2, from_address:, to_address:)
      rides = Ride.selectable
      data = described_class.call(rides:)

      expect(data.length).to eq(2)
      expect(data.all? { _1.distance_in_meters == 3105 && _1.duration == "577s" })
    end
  end

  it "caches for an hour" do
    VCR.use_cassette("first_ride_directions") do
      from_address = create(
        :address, :with_out_place_id, line_1: "711 Oval Drive", city: "Fort Collins", state: "CO",
        zip_code: "80521"
      )
      to_address = create(
        :address, :with_out_place_id, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
        zip_code: "80524"
      )
      create_list(:ride, 2, from_address:, to_address:)
      rides = Ride.selectable
      instance = described_class.new

      expect(instance).to receive(:connection).once.and_call_original

      # Call the method under test
      instance.call(rides:)

      # Mock the `connection` method to expect it not to be called on subsequent call
      allow(instance).to receive(:connection)
      expect(instance).to_not receive(:connection)

      # Expect `get_cached_response` to be called on subsequent call
      expect(instance).to receive(:get_cached_response)

      # Call the method again to trigger caching behavior
      instance.call(rides:)
    end
  end
end
