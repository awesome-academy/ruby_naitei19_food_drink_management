FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
    sequence(:slug) { |n| "category-#{n}" }
  end
end
