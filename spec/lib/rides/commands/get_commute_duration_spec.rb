# frozen_string_literal: true

RSpec.describe Rides::Commands::GetCommuteDuration do
  it "gets data for an address" do
    VCR.use_cassette("first_commute") do
      from_address = create(
        :address, :with_out_place_id, line_1: "4705 Weitzel Street", city: "Timnath", state: "CO",
        zip_code: "80547"
      )
      to_address = create(
        :address, :with_out_place_id, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
        zip_code: "80524"
      )
      create_list(:ride, 2, from_address:, to_address:)
      driver = create(:driver, current_address: from_address)
      rides = Ride.selectable
      data = described_class.call(rides:, driver:)

      expect(data.length).to eq(2)
      expect(data.all? { _1.duration == "577s" })
    end
  end
end
