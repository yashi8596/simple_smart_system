FactoryBot.define do
  factory :admin do
    employee_number { "98765432" }
    sequence(:email) { |n| "admin#{n}@exam.com" }
    password { "wa" }
    suspended { false }
  end
end