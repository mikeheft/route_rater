# frozen_string_literal: true

require "rails_helper"

RSpec.describe Driver, :skip_geocode, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:driver_addresses).dependent(:destroy) }
    it { is_expected.to have_one(:current_driver_address).inverse_of(:driver).dependent(:destroy) }
    it { is_expected.to have_one(:current_address).through(:current_driver_address).dependent(:destroy) }
  end

  describe "attributes" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end
end
