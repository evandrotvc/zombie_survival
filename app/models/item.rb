# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user, optional: true

  validates :kind, :point, presence: true
  validates_uniqueness_of :kind

  enum kind: {
    water: 'water', food: 'food', remedy: 'remedy', ammunition: 'ammunition'
  }

  # after_create :mark_count

  # def mark_count
  #   person_marked.infected! if quantity_marks > 2
  # end

  # def quantity_marks
  #   MarkSurvivor.where(person_marked: person_marked.id).count
  # end
end
