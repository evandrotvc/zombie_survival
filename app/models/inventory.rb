# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user#, inverse_of: :inventory

  has_many :items
  # has_many :items, through: :inventory_items
end
