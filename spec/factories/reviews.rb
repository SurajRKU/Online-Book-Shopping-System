
FactoryBot.define do
  factory :review do
    rating { 4 }
    review { "Great book!" }
    association :book
    association :user
  end
end
