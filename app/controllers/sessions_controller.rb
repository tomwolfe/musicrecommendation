class SessionsController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_signedin_path, notice: "Successfully signed in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_signedout_path, notice: "You have been logged out."
  end
end
