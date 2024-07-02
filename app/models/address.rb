# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :owner, polymorphic: true, optional: false

  validates :line_1, :city, :state, :zip_code, :latitude, :longitude, presence: true
end
