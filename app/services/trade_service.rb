class TradeService
    def initialize(user_from, user_to)
      @inventoryFrom = user_from.inventory
      @inventoryTo = user_to.inventory
      @itemsFrom = user_from.inventory.items
      @itemsTo = user_to.inventory.items
    end

    def trade(itemsFrom, itemsTo)
      return unless exists_items_inventory?(itemsFrom, itemsTo)

      return unless check_points_trade

      @itemsFrom.update_all(inventory_id: @inventoryTo.id)
      @itemsTo.update_all(inventory_id: @inventoryFrom.id)
    end

    def exists_items_inventory?(itemsFrom, itemsTo)
      @itemsFrom = @itemsFrom.where(kind: itemsFrom)
      @itemsTo = @itemsTo.where(kind: itemsTo)

      @itemsFrom.count == itemsFrom.count && @itemsTo.count == itemsTo.count
    end

    def check_points_trade
      @itemsFrom.pluck(:point).sum == @itemsTo.pluck(:point).sum
    end
  end
