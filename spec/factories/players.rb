FactoryBot.define do
  factory :player do
    sequence(:account_name) { |n| "name#{n}" }
    display_name { '表示名' }
    prefecture_code { '北海道' }
    sequence(:email) { |n| "email#{n}@email.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
