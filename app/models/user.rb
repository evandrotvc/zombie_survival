# frozen_string_literal: true

class User < ApplicationRecord
  has_many :inventories

  validates :name, :age, :latitude, :longitude, presence: true

  enum status: {
    survivor: 'survivor', infected: 'infected', dead: 'dead'
  }, _default: :survivor

  def create_mark_survivor(user_infected)
    MarkSurvivor.create!(
      user_report: self,
      user_marked: user_infected
    )
  end
end
