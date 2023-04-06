# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
  item1 = Item.where(kind: "water" , point: 4 ).first_or_create
  item2 = Item.where(kind: "food" , point: 3 ).first_or_create
  item3 = Item.where(kind: "remedy" , point: 2 ).first_or_create
  item4 = Item.where(kind: "ammunition" , point: 1 ).first_or_create

#   Character.create(name: "Luke", movie: movies.first)
