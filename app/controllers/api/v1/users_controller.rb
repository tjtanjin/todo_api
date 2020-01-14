class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :sendverification, :checkverification, :sendtelegram, :checktelegram]
  before_action :find_user, only: [:show, :update, :destroy, :setemailnotifications, :settelegramnotifications, :settelegramhandle]
  before_action :authorize_as_admin, only: [:index]
  before_action :authorize, only: [:update, :index, :show, :destroy, :setemailnotifications, :settelegramnotifications, :settelegramhandle]

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
      @user.generate_verification_token! #generate verification token
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

  def setemailnotifications
    @user.email_notifications = params[:email_notifications]
    if @user.save(validate: false)
      render json: { message: 'Notifications settings successfully updated.' }, status: 200
    else
      render json: { error: @user.errors.full_messages }, status: 400
    end
  end

  def settelegramnotifications
    @user.telegram_notifications = params[:telegram_notifications]
    if @user.save(validate: false)
      render json: { message: 'Notifications settings successfully updated.' }, status: 200
    else
      render json: { error: @user.errors.full_messages }, status: 400
    end
  end

  def sendverification
    if params[:email].blank? # check if email is present
      return render json: {error: 'Email cannot be empty'}, status: 400
    end

    @user = User.find_by(email: params[:email]) # if present find user by email

    if @user.present?
      if @user.verification_token == "1"
        return render json: {error: ['Account already verified.']}, status: 400
      else
        @user.generate_verification_token! #generate verification token
        UserNotifierMailer.send_signup_email(@user).deliver
        return render json: {message: 'Verification sent!'}, status: 200
      end
    else
      return render json: {error: ['Email address not found. Please check and try again.']}, status: 404
    end
  end

  def checkverification
    if params[:token].blank?
      return render json: {error: 'Verification token not found'}, status: 400
    else
      token = params[:token].to_s
    end

    @user = User.find_by(verification_token: token)

    if @user.present? && @user.verification_token_valid?
      @user.verification_token = "1"
      if @user.save(validate: false)
        render json: {message: "Account successfully verified!"}, status: 200
      else
        render json: {error: @user.errors.full_messages[-1]}, status: 400
      end
    else
      render json: {error:  ['Token not valid or expired. Login and click on the "Resend Verification Link" button again to generate a new token.']}, status: 404
    end
  end

  def settelegramhandle
    if @user.telegram_id != nil and @user.telegram_handle != params[:telegram_handle]
      @user.telegram_id = nil
      @user.telegram_notifications = "0"
    else
    end
    @user.telegram_handle = params[:telegram_handle]
    if @user.save(validate: false)
      render json: { message: 'Telegram handle successfully updated.' }, status: 200
    else
      render json: { error: @user.errors.full_messages }, status: 400
    end
  end

  def checktelegram
    if params[:email].blank?
      return render json: {error: 'Email not found'}, status: 400
    else
    end

    @user = User.find_by(email: params[:email])

    if @user.present? && (@user.telegram_handle == params[:telegram_handle])
      puts @user.telegram_id
      if @user.telegram_id != nil
        render json: {message: "Account already linked"}, status: 403
        return ;
      else
      end
      @user.telegram_id = params[:telegram_id]
      if @user.save(validate: false)
        render json: {message: "Telegram successfully linked!"}, status: 200
      else
        render json: {error: @user.errors.full_messages[-1]}, status: 400
      end
    else
      render json: {error:  ['User not found or telegram handle does not match.']}, status: 404
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
