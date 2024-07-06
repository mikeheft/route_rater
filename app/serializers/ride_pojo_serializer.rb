# frozen_string_literal: true

class RidePojoSerializer
  include JSONAPI::Serializer
  extend ActionView::Helpers::DateHelper
  extend ActionView::Helpers::NumberHelper

  set_id do |struct, _params|
    struct.ride_id
  end

  set_type "pre-ride"

  attribute :distance do |struct, _params|
    number_to_human((struct.distance_meters / 1609.34).round(2), units: :distance)
  end

  attribute :duration do |struct, _params|
    distance_of_time_in_words(struct.duration.to_f)
  end

  attribute :ride_earnings do |struct, _params|
    struct.ride_amount.format
  end

  belongs_to :from_address, serializer: AddressSerializer
  belongs_to :to_address, serializer: AddressSerializer
end
