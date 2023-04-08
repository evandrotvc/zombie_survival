# frozen_string_literal: true

class ItemsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_user, only: %i[add remove trade]
  
    def add
      @user.inventory.items.create(kind: item_params[:kind])
      render status: :ok, json: @item
    end
  
    def remove
      @item = @user.inventory.items.find_by(kind: item_params[:kind])

      if @item.destroy
        render status: :ok, json: @item
      else
        render :errors, status: :unprocessable_entity
      end
    end

    def trade
      @user_to = User.find_by(name: params[:name])
      render status: :ok, json: @user
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  
    def item_params
      params.require(:item).permit(:kind)
    end
  end
