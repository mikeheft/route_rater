FactoryBot.define do
  factory :address do
    line_1 { "MyString" }
    line_2 { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    owner { nil }
  end
end
