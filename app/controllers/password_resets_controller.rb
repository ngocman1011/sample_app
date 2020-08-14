class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
                only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset.sent"
      redirect_to root_path
    else
      flash.now[:danger] = t "reset.email_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("reset.empty"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = t "reset.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "user.notfound"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "reset.expired"
    redirect_to new_password_reset_path
  end
end
