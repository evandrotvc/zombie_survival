# frozen_string_literal: true

FactoryBot.define do
  factory :inventory do
    user { create(:user) }
  end
end
