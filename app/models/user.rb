# frozen_string_literal: true

class User < ApplicationRecord
  # has_one :inventory
  has_one :inventory, inverse_of: :user, dependent: nil

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
