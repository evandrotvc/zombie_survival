# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user

  has_many :items, dependent: :destroy

  def all_items_in_inventory?(items_array)
    items.where(kind: items_array).count == items_array.count
  end

  def teste(items_array)
    byebug
  end
end
