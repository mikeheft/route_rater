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
end
