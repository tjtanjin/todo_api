class Api::V1::PasswordsController < ApplicationController
	skip_before_action :authenticate_request

	# Function to check validity of email and send password reset token to user
	def forgot
	  if params[:email].blank? # check if email is present
	    return render json: {error: 'Please enter your email'}, status: 400
	  end

	  @user = User.find_by(email: params[:email]) # if present find user by email

	  if @user.present?
	    @user.generate_password_token! #generate pass token
	    UserNotifierMailer.send_reset_password_email(@user).deliver
	    return render json: {message: 'Password reset token sent!'}, status: 200
	  else
	    return render json: {error: ['Email address not found. Please check and try again.']}, status: 404
	  end
	end

	# Function to reset password of user when provided with correct token
	def reset
	  if params[:token].blank?
	  	return render json: {error: 'Please enter your password reset token'}, status: 400
	  else
	  	token = params[:token].to_s
	  end

	  if params[:email].blank?
	    return render json: {error: 'An error has occurred, please try to generate a new token or contact an administrator.'}, status: 400
	  end

	  if params[:password].blank?
	  	return render json: {error: 'Please enter your new password'}, status: 400
	  end

	  @user = User.find_by(reset_password_token: token)

	  if @user.present? && @user.password_token_valid?
	 	  @user.reset_password_token = nil
      @user.password = params[:password]
	    if @user.save
	      render json: {message: 'Password reset successful!'}, status: 200
	    else
	      render json: {error: @user.errors.full_messages[-1]}, status: 400
	    end
	  else
	    render json: {error:  ['Token not valid or expired. Try generating a new token.']}, status: 404
	  end

	end

end
