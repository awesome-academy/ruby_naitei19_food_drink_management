FactoryBot.define do
  factory :category do
    name { "Category 1" }
    sequence(:slug) { |n| "category-#{n}" }
  end
end
