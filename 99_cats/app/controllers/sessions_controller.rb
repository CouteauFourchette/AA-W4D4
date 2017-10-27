class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_credentials(params[:user_name], params[:password])
    if user
      login_user!(user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Wrong username or password"]
      render :new
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
      redirect_to cats_url
    end
  end
end
