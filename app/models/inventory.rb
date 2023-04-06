# frozen_string_literal: true

class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :item
end
