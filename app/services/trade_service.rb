# frozen_string_literal: true

class TradeService
  include ActiveModel::Model

  ITEM_POINTS = {
    water: 4,
    food: 3,
    medicine: 2,
    ammunition: 1
  }.freeze

  validate :infected?

  def initialize(user_from, user_to)
    @inventoryFrom = user_from.inventory
    @inventoryTo = user_to.inventory
    @itemsFrom = user_from.inventory.items
    @itemsTo = user_to.inventory.items
  end

  def execute(items_from, items_to)
    return unless valid?

    return unless exists_items_inventory?(items_from, items_to)

    return unless check_points_trade(items_from, items_to)

    update_inventory(items_to, items_from, @inventoryFrom)
    update_inventory(items_from, items_to, @inventoryTo)
  end

  def update_inventory(items_receive, items_loss, inventory)
    receive_items(items_receive, inventory)
    loss_items(items_loss, inventory)
  end

  def receive_items(items_receive, inventory)
    items_receive.each do |item|
      itemUser = inventory.items.find_or_create_by(kind: item[:kind])

      itemUser.quantity += item[:quantity].to_i
      itemUser.save!
    end
  end

  def loss_items(items_loss, inventory)
    items_loss.each do |item|
      itemUser = inventory.items.find_by(kind: item[:kind])
      itemUser.quantity -= item[:quantity].to_i
      itemUser.save!
    end
  end

  def exists_items_inventory?(items_from, items_to)
    @itemsFrom = @itemsFrom.where(kind: items_from.pluck(:kind))
    @itemsTo = @itemsTo.where(kind: items_to.pluck(:kind))

    check_quantity(items_from, @inventoryFrom)
    check_quantity(items_to, @inventoryTo)

    true
  end

  def check_quantity(items, inventory)
    items.map do |item|
      item_user = inventory.items.find_by(kind: item[:kind])

      if item_user.nil? || item_user.quantity < item[:quantity].to_i
        raise TradeError,
          "#{inventory.user.name} dont have #{item[:kind]} or quantity insuficient!"
      end
    end
  end

  def check_points_trade(items_from, items_to)
    return true if calculate_points(items_from) == calculate_points(items_to)

    raise TradeError, 'Items points are insuficients for the trade!'
  end

  private

  def calculate_points(items)
    points = 0
    items.to_a.each do |item|
      points += ITEM_POINTS[item[:kind].to_sym] * item[:quantity].to_i
    end
    points
  end

  def infected?
    return true unless @inventoryFrom.user.infected? || @inventoryTo.user.infected?

    raise TradeError, 'Users infecteds cannot to trade items!'
  end
end
