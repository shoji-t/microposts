class UsersController < ApplicationController
  before_action :set_params, only: [:show, :edit, :update, :followings, :followers]
  before_action :correct_user, only: [:edit, :update]

  def show # 追加
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Updated your Plofile"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def favorite
    @title = 'Favorite Microposts'
    @micropost = current_user.microposts.build
    @feed_microposts = current_user.favorite_microposts.paginate(page: params[:page])
    render template: 'about/index'
  end
  
  def followings
    @title = "Following"
    @users = @user.following_users
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @users = @user.follower_users
    render 'show_follow'
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :profile,
                                   :password_confirmation)
  end
  
  def set_params
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to root_path if @user != current_user
  end
end