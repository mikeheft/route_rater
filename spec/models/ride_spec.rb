# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ride, :skip_geocode, type: :model do
  subject { create(:ride) }
  describe "associations" do
    it { is_expected.to belong_to(:driver).optional(true) }
    it { is_expected.to belong_to(:from_address).class_name("Address") }
    it { is_expected.to belong_to(:to_address).class_name("Address") }
  end

  describe "attributes" do
    it { is_expected.to monetize(:amount_cents).as(:amount) }
    it { is_expected.to validate_numericality_of(:amount_cents) }
  end

  describe "scopes" do
    it ".nearby_drivers" do
      VCR.use_cassette("nearby_drivers") do
        from_address = create(
          :address, line_1: "4705 Weitzel Street", city: "Timnath", state: "CO",
          place_id: "ChIJ0zbP73SzbocR7mXVIY-QdBM",
          zip_code: "80547"
        )
        to_address = create(
          :address, :with_out_place_id, line_1: "151 N College Ave", city: "Fort Collins", state: "CO",
          place_id: "ChIJlRJnwIpKaYcRYzG0fYZOwpY",
          zip_code: "80524"
        )
        create_list(:ride, 2, from_address:, to_address:)
        driver = create(:driver, current_address: to_address)
        rides = Ride.selectable.nearby_driver(driver)
        binding.pry
      end
    end
  end
end
