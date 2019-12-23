class Api::V1::AuthenticationController < ApplicationController
 skip_before_action :authenticate_request

 def authenticate
   command = AuthenticateUser.call(params[:email], params[:password])

   if command.success?
     render json: command.result
   else
     render json: { error: "Invalid credentials!" }, status: :unauthorized
   end
 end
end
