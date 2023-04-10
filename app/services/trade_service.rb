# frozen_string_literal: true

class TradeService
  include ActiveModel::Model

  ITEM_POINTS = {
    water: 4,
    food: 3,
    medicine: 2,
    ammunition: 1
  }

  validate :infected?

  def initialize(user_from, user_to)
    @inventoryFrom = user_from.inventory
    @inventoryTo = user_to.inventory
    @itemsFrom = user_from.inventory.items
    @itemsTo = user_to.inventory.items
  end

  def execute(itemsFrom, itemsTo)
    return unless valid?

    return unless exists_items_inventory?(itemsFrom, itemsTo)

    return unless check_points_trade(itemsFrom, itemsTo)

    update_inventory(itemsTo, itemsFrom, @inventoryFrom)
    update_inventory(itemsFrom, itemsTo, @inventoryTo)
  end

  def update_inventory(itemsReceive, itemsLoss, inventory)
    receive_items(itemsReceive, inventory)
    loss_items(itemsLoss, inventory)
  end

  def receive_items(itemsReceive, inventory)
    itemsReceive.each do |item|
      itemUser = inventory.items.find_or_create_by(kind: item[:kind])

      itemUser.quantity += item[:quantity].to_i
      itemUser.save!
    end
  end

  def loss_items(itemsLoss, inventory)
    itemsLoss.each do |item|
      itemUser = inventory.items.find_by(kind: item[:kind])
      itemUser.quantity -= item[:quantity].to_i
      itemUser.save!
    end
  end

  def exists_items_inventory?(itemsFrom, itemsTo)
    @itemsFrom = @itemsFrom.where(kind: itemsFrom.pluck(:kind))
    @itemsTo = @itemsTo.where(kind: itemsTo.pluck(:kind))

    check_quantity(itemsFrom, @inventoryFrom)
    check_quantity(itemsTo, @inventoryTo)

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

  def check_points_trade(itemsFrom, itemsTo)
    return true if calculate_points(itemsFrom) == calculate_points(itemsTo)

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
