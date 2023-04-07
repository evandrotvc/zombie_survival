# frozen_string_literal: true

class Item < ApplicationRecord
  has_many :inventories
  # has_many :inventories, through: :inventory_items

  validates :kind, :point, presence: true
  validates_uniqueness_of :kind

  enum kind: {
    water: 'water', food: 'food', remedy: 'remedy', ammunition: 'ammunition'
  }

end
