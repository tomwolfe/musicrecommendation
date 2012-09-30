class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, notice: "Thanks for joining"
    else
      render "new"
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, notice: "Your profile has been updated."
    else
      render "edit"
    end
  end
end
