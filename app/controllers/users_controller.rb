class UsersController < ApplicationController
  respond_to :html, :json

  def new
    @user = User.new
  end

  def index
    @users = User.all

    if session[:user]
      redirect_to music_url
    else
      respond_with @users
    end

  end

  def show
    @user = User.find(params[:id])

    #THIS IS JUST TEMPORARY!
    session[:user] = @user.name
    session[:user_id] = @user.id

    redirect_to music_url

  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
end