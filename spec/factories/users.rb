FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }

    factory :user_with_names do
      transient do
        names_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:todo_item, evaluator.names_count, user: user)
      end
    end

    factory :user_with_completed_names do
      transient do
        names_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:completed_todo_item, evaluator.names_count, user: user)
      end
    end
  end
end
