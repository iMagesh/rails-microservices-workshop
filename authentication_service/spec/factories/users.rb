# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "testpassword" }
    # Add other attributes as needed
  end
end
