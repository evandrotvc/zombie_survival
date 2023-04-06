# frozen_string_literal: true

class User < ApplicationRecord
  has_many :inventories, dependent: :destroy

  validates :name, :age, :latitude, :longitude, presence: true

  enum status: {
    survivor: 'survivor', infected: 'infected', dead: 'dead'
  }, _default: :survivor

end
