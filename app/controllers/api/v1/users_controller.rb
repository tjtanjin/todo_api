class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :find_user, only: [:show, :update, :destroy]
  before_action :authorize_as_admin, only: [:index]
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
      UserNotifierMailer.send_signup_email(@user).deliver
      render json: AuthenticateUser.call(@user.email, @user.password).result, status: 200
    else 
      render json: { error: @user.errors.full_messages[-1] }, status: 400
    end
  end

  # Update User
  def update
    if @user
      if current_user.role == "admin"
        @user.assign_attributes(user_params)
        @user.save(validate: false)
        render json: { message: 'User successfully updated.' }, status: 200
      else
        if @user.update(user_params)
          render json: { message: 'Profile successfully updated.' }, status: 200
        else
          render json: { error: @user.errors.full_messages[-1] }, status: 400
        end
      end
    else
      render json: { error: 'Unable to update user.' }, status: 400
    end
  end

  # Delete user
  def destroy
    if @user
      @user.destroy
      UserNotifierMailer.send_farewell_email(@user).deliver
      render json: { message: 'User successfully deleted.' }, status: 200
    else
      render json: { error: 'Unable to delete user.' }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def authorize
    return head(:unauthorized) unless current_user && current_user.can_modify_user?(params[:id])
  end

end
