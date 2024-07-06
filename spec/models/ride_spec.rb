# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ride, type: :model do
  subject { create(:ride) }
  describe "associations", :skip_geocode do
    it { is_expected.to belong_to(:driver).optional(true) }
    it { is_expected.to belong_to(:from_address).class_name("Address") }
    it { is_expected.to belong_to(:to_address).class_name("Address") }
  end

  describe "attributes", :skip_geocode do
    it { is_expected.to monetize(:amount_cents).as(:amount) }
    it { is_expected.to validate_numericality_of(:amount_cents) }
  end

  describe "scopes" do
    describe ".nearby_drivers" do
      it "gets rides within the driver's default max_radius (defaults to 10mi.)" do
        VCR.use_cassette("nearby_drivers") do
          from_address_1 = create(
            :address, :with_out_location_data, line_1: "4705 Weitzel Street", city: "Timnath", state: "CO",
            zip_code: "80547"
          )
          to_address_1 = create(
            :address, :with_out_location_data, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
            zip_code: "80524"
          )
          create(:ride, from_address: from_address_1, to_address: to_address_1)
          from_address_2 = create(
            :address, :with_out_location_data, line_1: " 216 N College Ave #110", city: "Fort Collins", state: "CO",
            zip_code: "80524"
          )
          to_address_2 = create(
            :address, :with_out_location_data, line_1: "501 W 20th St", city: "Greeley", state: "CO",
            zip_code: "80639"
          )
          create(:ride, from_address: from_address_2, to_address: to_address_2)
          driver = create(:driver, current_address: to_address_1)
          rides = Ride.selectable.nearby_driver(driver)

          expect(rides.length).to eq(2)
        end
      end

      it "gets rides near drivers with different max_radius" do
        VCR.use_cassette("nearby_drivers") do
          from_address_1 = create(
            :address, :with_out_location_data, line_1: "4705 Weitzel Street", city: "Timnath", state: "CO",
            zip_code: "80547"
          )
          to_address_1 = create(
            :address, :with_out_location_data, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
            zip_code: "80524"
          )
          create(:ride, from_address: from_address_1, to_address: to_address_1)
          from_address_2 = create(
            :address, :with_out_location_data, line_1: " 216 N College Ave #110", city: "Fort Collins", state: "CO",
            zip_code: "80524"
          )
          to_address_2 = create(
            :address, :with_out_location_data, line_1: "501 W 20th St", city: "Greeley", state: "CO",
            zip_code: "80639"
          )
          create(:ride, from_address: from_address_2, to_address: to_address_2)
          driver = create(:driver, current_address: from_address_2, max_radius: 5)
          rides = Ride.selectable.nearby_driver(driver)

          # Since the driver's current home address is in Greeley,
          # The Timnath ride(from_address) is too far away as well as the Fort Collins ride (from_address_2)
          expect(rides.length).to eq(0)
        end
      end
    end
  end
end
