# frozen_string_literal: true

FactoryBot.define do
  factory :driver do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    association :current_address, factory: :address
  end
end
