# frozen_string_literal: true

require "rails_helper"

RSpec.describe DriverAddress, :skip_geocode, type: :model do
  subject { create(:driver_address) }
  describe "associations" do
    it { is_expected.to belong_to(:driver) }
    it { is_expected.to belong_to(:address) }

    it do
      is_expected.to validate_uniqueness_of(:current)
        .scoped_to(:driver_id)
        .with_message("can only have one current Driver")
    end
  end
end
