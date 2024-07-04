# frozen_string_literal: true

FactoryBot.define do
  factory :ride do
    duration { nil }
    commute_duration { nil }
    distance { nil }
    amount_cents { 0 }

    driver { nil }

    association :from_address, factory: :address
    association :to_address, factory: :address
  end
end
