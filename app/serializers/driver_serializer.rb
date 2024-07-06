# frozen_string_literal: true

class DriverSerializer
  include JSONAPI::Serializer
  set_type :driver
  attributes :id, :full_name
  has_one :current_address, serializer: AddressSerializer
end
