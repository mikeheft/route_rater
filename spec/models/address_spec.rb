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
    it "can query for associated rides" do
      ride = create(:ride)
      from_address = ride.from_address
      to_address = ride.to_address

      expect(from_address.rides).to include(ride)
      expect(to_address.rides).to include(ride)
    end
  end
end
