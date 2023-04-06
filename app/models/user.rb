# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, :age, :latitude, :longitude, presence: true

  has_many :items, dependent: :destroy

  enum status: {
    survivor: 'survivor', infected: 'infected', dead: 'dead'
  }, _default: :survivor

end
