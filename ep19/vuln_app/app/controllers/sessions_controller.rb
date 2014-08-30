class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && verify_recaptcha
      redirect_to step_two_sessions_path(:username => params[:username])
    else
      render "new"
    end
  end
  
  def step_two
    
  end
  
  def login
    user = User.authenticate(params[:username], params[:password])
    if user     
     session[:id] = user.id
     redirect_to new_home_path
    else
     render "new"
    end
  end
  
  def destroy
    session[:id] = nil
    reset_session
    render "new"
  end
  
end
