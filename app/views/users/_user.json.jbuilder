# frozen_string_literal: true

json.extract! user, :id, :name, :gender, :status,
  :latitude, :longitude, :created_at, :updated_at

json.inventory user.inventory.items.each do |item|
  json.extract! item, :id, :kind, :quantity
end
