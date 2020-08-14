class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]

  def show
    @microposts = @user.microposts.recent_posts.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "email.check"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.edit_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.delete_user"
    else
      flash[:danger] = t "user.delete_fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.login"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user?(@user)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user.notfound"
    redirect_to root_path
  end
end
