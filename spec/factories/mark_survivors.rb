# frozen_string_literal: true

FactoryBot.define do
  factory :mark_survivor do
    user_marked { create(:user) }
    user_report { create(:user) }
  end
end
