# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    line_1 { Faker::Address.street_address }
    line_2 { nil }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip_code { Faker::Address.zip_code }
    place_id { nil }
    latitude { nil }
    longitude { nil }

    trait :with_out_place_id do
      place_id { nil }
    end
  end
end
