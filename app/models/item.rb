# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :inventory

  validates :kind, :point, presence: true

  enum kind: {
    water: 'water', food: 'food', remedy: 'remedy', ammunition: 'ammunition'
  }

end
