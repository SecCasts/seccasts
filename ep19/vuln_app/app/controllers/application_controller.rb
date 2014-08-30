class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :authenticated
  
  def current_user
    @current_user ||= User.find_by_id(session[:id])
  end
  
  def authenticated
    if not current_user
      redirect_to new_session_path
    end
  end
  
end
