# frozen_string_literal: true

FactoryBot.define do
  factory :ride do
    duration { 2.3 }
    commute_duration { 1.0 }
    distance { 30.1 }
    amount_cents { 1200 }

    driver { nil }

    association :from_address, factory: :address
    association :to_address, factory: :address
  end
end
