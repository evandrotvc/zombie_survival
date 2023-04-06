# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    gender { Faker::Gender.binary_type }
    age { Faker::Number.number(digits: 2) }
    status { :survivor }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
