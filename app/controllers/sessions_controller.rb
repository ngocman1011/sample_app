class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t("email.acc_not_activated") + t("email.check")
        redirect_to root_path
      end
    else
      flash.now[:danger] = t "user.fail"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
