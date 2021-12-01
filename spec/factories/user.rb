FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }

    factory :user_with_names do
      transient do
        names_count { 5 }
      end
    end

    factory :user_with_completed_names do
      transient do
        names_count { 5 }
      end
    end
  end
end
