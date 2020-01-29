module Api
  class FriendsController < ApplicationController
    before_action :set_user

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end

    def index
      friends = @user.friends.all
      render json: friends
    end

    def create
      @friend = @user.friends.new(friend_params)
      if @friend.save
        render json: @friend, status: :created
      else
        render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
      end
    end

    protected

      def set_user
        @user = User.where(id: params[:user_id]).first
      end
      
      def friend_params
        params.require(:friend).permit(:id, :user_id, :name, :email, :description)
      end

  end
end
