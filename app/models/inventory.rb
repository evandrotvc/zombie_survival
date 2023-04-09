# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user

  has_many :items, dependent: :destroy
end
