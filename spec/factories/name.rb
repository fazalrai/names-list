FactoryBot.define do
  factory :name do
    title { Faker::Name.name }

    association :user
    association :list
  end
end
