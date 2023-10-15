class UsersController < ApplicationController
  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end

  def show
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path(user.id)
  end


  private

  def usr_params
    params.require(:user).permit(:name, :profile_omage, :introduction)
  end
end
