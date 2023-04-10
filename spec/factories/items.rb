# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    kind { 'water' }
    quantity { 1 }

    inventory { create(:inventory) }
  end
end
