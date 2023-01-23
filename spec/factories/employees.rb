FactoryBot.define do
  factory :employee do
    employee_number { "12345678" }
    sequence(:email) { |n| "employee#{n}@exam.com" }
    last_name { "山田" }
    first_name { "太郎" }
    last_name_kana { "ヤマダ" }
    first_name_kana { "タロウ" }
    password { "pw" }
    address { "愛知県愛知市愛知町4-5-6" }
    telephone_number { "09098765432" }
    number_of_paid_leave { "10" }
    start_date { Date.yesterday }
    end_date { nil }
    suspended { false }
  end
end