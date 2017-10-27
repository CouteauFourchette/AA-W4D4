class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    token = SessionToken.find_by(token: session[:session_token])
    if token
      @current_user ||= token.user
    else
      nil
    end
  end

  def logged_in?
    !!current_user
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

end
