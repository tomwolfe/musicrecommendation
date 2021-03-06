class UsersController < ApplicationController
	skip_before_filter :authorize, only: [:new, :create]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if verify_recaptcha(model: @user, message: "reCaptcha error") && @user.save
			session[:user_id] = @user.id
			redirect_to home_signedin_path, notice: "Thanks for joining!"
		else
			render :new
		end
	end

	def edit
		@user = current_user
		fresh_when @user
	end

	def update
		@user = current_user
		if @user.update(user_params)
			redirect_to home_signedin_path, notice: "Your profile has been updated."
		else
			render :edit
		end
	end

	private
		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
end
