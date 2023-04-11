# frozen_string_literal: true

class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: %i[add remove trade]
  before_action :infected?, only: %i[add remove]

  rescue_from TradeError, with: :trade_error

  def add
    @item = @user.inventory.items.find_by(kind: item_params[:kind])

    if @item.present?
      add_item
    else
      @item = @user.inventory.items.create(kind: item_params[:kind],
        quantity: item_params[:quantity])
    end
    render status: :ok, json: { item: @item }
  end

  def remove
    @item = @user.inventory.items.find_by(kind: item_params[:kind])

    if @item.destroy
      render status: :ok, json: { item: @item }
    else
      render :errors, status: :unprocessable_entity
    end
  end

  def trade
    @user_to = User.find_by(name: user_to_params[:name])

    TradeService.new(@user, @user_to).execute(user_from_params[:items],
      user_to_params[:items])

    render :trade, status: :ok
  end

  private

  def trade_error(exception)
    render json: { message: exception.message },
      status: :unprocessable_entity
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def item_params
    params.require(:item).permit(:kind, :quantity)
  end

  def user_from_params
    params.require(:user).permit(items: %i[kind quantity])
  end

  def user_to_params
    params.require(:user_to).permit(:name, items: %i[kind quantity])
  end

  def infected?
    raise TradeError, 'Users infecteds cannot to use inventory!' if @user.infected?
  end

  def add_item
    @item.update(quantity: @item.quantity + item_params[:quantity].to_i)
  end
end
