# frozen_string_literal: true

class AddressSerializer
  include JSONAPI::Serializer
  set_type :address
  attributes :line_1, :line_2, :city, :state, :zip_code, :full_address
end
