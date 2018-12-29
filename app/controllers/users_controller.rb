class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
   private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
end
