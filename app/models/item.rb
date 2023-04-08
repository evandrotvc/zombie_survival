# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :inventory

  validates :kind, presence: true

  enum kind: {
    water: 'water', food: 'food', remedy: 'remedy', ammunition: 'ammunition'
  }

  before_create :set_points

  private

  def set_points
    case kind
    when "water"
      self.point = 4
    when "food"
      self.point =  3
    when "remedy"
      self.point =  2
    else
      self.point =  1
    end
  end
end