# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    kind { 'water' }
    point { 4 }

    inventory { create(:inventory) }
  end
end
