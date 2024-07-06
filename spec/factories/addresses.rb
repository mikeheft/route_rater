# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    line_1 { Faker::Address.street_address }
    line_2 { nil }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip_code }
    place_id { Faker::Internet.unique.device_token }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :with_out_location_data do
      place_id { nil }
      latitude { nil }
      longitude { nil }
    end
  end
end
