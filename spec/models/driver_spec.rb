# frozen_string_literal: true

require "rails_helper"

RSpec.describe Driver, type: :model do
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to have_one(:address) }
end
