FactoryBot.define do
  factory :book do
    isbn { "1234567890" }
    name { "Test Book" }
    author { "Test Author" }
    publisher { "Test Publisher" }
    price { 10.99 }
    stock { 5 }
  end
end