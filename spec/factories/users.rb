FactoryBot.define do
  factory :user do
    username { "testuser" }
    password { "password" }
    name { "Test User" }
    email { "test@example.com" }
    address { "123 Test St" }
    phone_number { "1234567890" }
    encrypted_password { "encrypted_password" }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
  end
end