# frozen_string_literal: true

RSpec.describe Rides::Commands::GetDirectionData do
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
      ride = create(:ride, from_address:, to_address:)
      data = described_class.call(ride:)
      binding.pry
    end
  end
end
