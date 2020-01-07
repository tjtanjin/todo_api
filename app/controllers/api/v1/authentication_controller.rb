class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def authenticate
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      if command.result[:isVerified]
      	render json: command.result
      else
      	render json: { error: 'Please check your email for instructions to verify your account!' }, status: 400
      end
    else
      render json: { error: "Invalid credentials!" }, status: :unauthorized
    end
  end
end
