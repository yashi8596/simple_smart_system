FactoryBot.define do
  factory :admin do
    sequence(:employee_number) { |n| "admin_employee_number_#{n}" }
    sequence(:email) { |n| "admin#{n}@exam.com" }
    password { "wa" }
    suspended { false }
  end
end