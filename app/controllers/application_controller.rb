class ApplicationController < ActionController::API
 before_action :authenticate_request
  attr_reader :current_user

  private

  # authenticates request call
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  protected

  # authorization for admin
  def authorize_as_admin
    return head(:method_not_allowed) unless !current_user.nil? && current_user.is_admin?
  end

end
