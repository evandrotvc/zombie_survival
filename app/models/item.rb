# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :inventory

  validates :kind, :quantity, presence: true

  enum kind: {
    water: 'water', food: 'food', remedy: 'remedy', ammunition: 'ammunition'
  }

  before_create :set_points
  after_update :quantity_zero?

  private

  def set_points
    self.point = case kind
                 when 'water'
                   4
                 when 'food'
                   3
                 when 'remedy'
                   2
                 else
                   1
                 end
  end

  def quantity_zero?
    self.destroy if quantity == 0
  end
end
