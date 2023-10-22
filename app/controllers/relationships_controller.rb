class RelationshipsController < ApplicationController

  # フォローするとき
  def create
    user_to_follow = User.find(params[:user_id])
    unless current_user == user_to_follow
      current_user.follow(params[:user_id])
    end
    redirect_back(fallback_location: users_path)
  end

  # フォロー外すとき
  def destroy
    user_to_unfollow = User.find(params[:user_id])
    unless current_user == user_to_unfollow
      current_user.unfollow(params[:user_id])
    end
    redirect_back(fallback_location: users_path)
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
