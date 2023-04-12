# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user,
    only: %i[show edit update destroy location infected]

  def index
    @users = User.all

    render :index, status: :ok
  end

  def show
    render status: :ok, json: @user
  end

  def new
    @user = User.new
  end

  def edit; end

  def infected
    @user_target = User.find_by(name: params[:name_target])

    mark = @user.create_mark_survivor(@user_target)

    if mark
      render status: :ok,
        json: { message: "#{@user_target.name} marked with sucess.",
                user_target: @user_target }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: :unprocessable_entity,
      json: { message: "Error: #{@user_target.name} already was marked for you" }
  end

  def create
    @user = User.new(user_params)

    if @user.save
      Inventory.create(user: @user)

      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def location
    if @user.update(location_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!

    render status: :ok, json: { message: 'User was destroyed with sucess' }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :gender, :age, :latitude, :longitude)
  end

  def location_params
    params.require(:location).permit(:latitude, :longitude)
  end
end
