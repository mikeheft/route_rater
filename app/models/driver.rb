# frozen_string_literal: true

class Driver < ApplicationRecord
  has_one :address, as: :owner, dependent: :destroy

  validates :first_name, :last_name, presence: true
end
