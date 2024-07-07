# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:driver_addresses).dependent(:destroy) }
  end

  describe "attributes" do
    it { is_expected.to validate_presence_of(:line_1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:zip_code) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
  end

  describe "instance_methods" do
    it "#rides", :skip_geocode do
      ride = create(:ride)
      from_address = ride.from_address
      to_address = ride.to_address

      expect(from_address.rides).to include(ride)
      expect(to_address.rides).to include(ride)
    end

    it "#full_address" do
      VCR.use_cassette("initial_geocode") do
        address = create(:address, :with_out_location_data, line_1: "711 Oval Drive", city: "Fort Collins", state: "CO",
          zip_code: "80521")
        expect(address.full_address).to eq("711 Oval Drive, Fort Collins, CO, 80521")
        expect(address.latitude).to eq(40.577655)
        expect(address.longitude).to eq(-105.0817584)
        expect(address.place_id).to eq("ChIJ4_pqNVhKaYcRRIu73kU9GFw")
      end
    end
  end
end
