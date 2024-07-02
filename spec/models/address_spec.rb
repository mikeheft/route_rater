# frozen_string_literal: true

require "rails_helper"

RSpec.describe Address, type: :model do
  it { is_expected.to have_many(:driver_addresses) }
  it { is_expected.to have_one(:current_driver).through(:current_driver_address) }

  it { is_expected.to validate_presence_of(:line_1) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }

  describe "instance_methods" do
    it "can query for associated rides" do
    end
  end
end
