class ReportsController < ApplicationController
  def infected_percentage
    infected_users = User.where(status: :infected).count
    total_users = User.count
    percentage = (infected_users.to_f / total_users.to_f) * 100
    render plain: "Percentage of infecteds users: #{percentage}%"
  end

  def non_infected_percentage
    non_infected_users = User.where(status: :infected).count
    total_users = User.count
    percentage = (non_infected_users.to_f / total_users.to_f) * 100
    render plain: "Percentage of non-infected users: #{percentage}%"
  end

  def average_items_per_user
    average_waters = Item.water.sum(:quantity) / User.count.to_f
    average_foods = Item.food.sum(:quantity) / User.count.to_f
    average_ammunitions = Item.ammunition.sum(:quantity) / User.count.to_f
    average_remedies = Item.remedy.sum(:quantity) / User.count.to_f
    render plain: "Average quantity of each type of item per user: water/user: #{average_waters}, food/user: #{average_foods}
    ammunition/user: #{average_ammunitions}, Remedies/user: #{average_remedies}"
  end

  def lost_points
    infected_users = User.infected
    lost_points = infected_users.map { |user| user.inventory.items.sum(:point) }.sum

    render plain: "Número de pontos perdidos por usuários infectados: #{lost_points}"
  end
end
