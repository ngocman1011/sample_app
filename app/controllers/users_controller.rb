class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
       @user = User.new(name: "", email: "")
    else
      render :show
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = message
      if I18n.locale = :vi
        message = "Không tìm thấy người dùng!"
      else
        message = "Not found this user!"
      end
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end
end
