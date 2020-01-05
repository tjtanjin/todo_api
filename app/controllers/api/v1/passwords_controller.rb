class Api::V1::PasswordsController < ApplicationController
	skip_before_action :authenticate_request

	def forgot
	  if params[:email].blank? # check if email is present
	    return render json: {error: 'Email not present'}
	  end

	  @user = User.find_by(email: params[:email]) # if present find user by email

	  if @user.present?
	    @user.generate_password_token! #generate pass token
	    UserNotifierMailer.send_reset_password_email(@user).deliver
	    render json: {status: 'ok'}, status: 200
	  else
	    render json: {error: ['Email address not found. Please check and try again.']}, status: 404
	  end
	end

	def reset
	  token = params[:token].to_s

	  if params[:email].blank?
	    return render json: {error: 'Token not present'}
	  end

	  @user = User.find_by(reset_password_token: token)

	  if @user.present? && @user.password_token_valid?
	    if @user.reset_password!(params[:password])
	      render json: {status: 'ok'}, status: 200
	    else
	      render json: {error: @user.errors.full_messages}, status: :unprocessable_entity
	    end
	  else
	    render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: 404
	  end

	end

end
