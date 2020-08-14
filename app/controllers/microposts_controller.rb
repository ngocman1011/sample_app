class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach micropost_params[:image]
    if @micropost.save
      flash[:success] = t "microposts.created"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.deleted"
    else
      flash[:danger] = t "microposts.delete_fail"
    end
    redirect_to request.referer || root_path
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "microposts.access_error"
    redirect_to root_path
  end

  def micropost_params
    params.require(:micropost).permit :content, :image
  end
end
