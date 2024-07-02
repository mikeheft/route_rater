class DriverAddress < ApplicationRecord
  belongs_to :driver
  belongs_to :address

  validates :current,
    if: -> { current },
    uniqueness: { scope: :driver_id, message: "can only have one current Driver" },
    inclusion: { in: [true, false] }
end
