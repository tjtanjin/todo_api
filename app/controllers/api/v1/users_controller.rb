class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :authorize, only: [:update, :index, :show, :destroy]

  # Get All Users
  def index
    @users = User.all
    render json: @users
  end

  # Get Specific User
  def show
    render json: @user
  end

  # Create User
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user
    else
      render json: { error: 'Unable to create user.' }, status: 400
    end
  end

  # Update User
  def update
    if @user
      @user.update(user_params)
      render json: { message: 'User successfully updated.' }, status: 200
    else
      render json: { error: 'Unable to update user.' }, status: 400
    end
  end

  # Delete user
  def destroy
    if @user
      @user.destroy
      render json: { message: 'User successfully deleted.' }, status: 200
    else
      render json: { error: 'Unable to delete user.' }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authorize
    return head(:unauthorized) unless current_user && current_user.can_modify_user?(params[:id])
  end

end
