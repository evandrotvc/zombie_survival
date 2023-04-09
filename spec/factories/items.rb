# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    kind { 'water' }

    inventory { create(:inventory) }
  end
end
