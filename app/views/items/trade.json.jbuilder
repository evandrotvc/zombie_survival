json.user_from do
    json.extract! @user, :name, :status

    json.inventory @user.inventory.items.each do |item|
    json.extract! item, :id, :kind, :quantity
    end
end

json.user_to do
    json.extract! @user_to, :name, :status

    json.inventory @user_to.inventory.items.each do |item|
    json.extract! item, :id, :kind, :quantity
    end
end