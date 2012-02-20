class ApplicationController < ActionController::Base

  before_filter :set_current_user

  def set_current_user
    User.current = session[:user]
  end

end
