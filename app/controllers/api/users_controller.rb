module Api
  class UsersController < ApplicationController
    # 管理者としてで使うかも〜
    before_action :set_user, only: [:show]
    
    # GET /api/users  
    def index
      users = User.all
      render json: { data: users }
    end
    
    # GET /api/users/1
    def show
      render json: { data: @user }
    end


    private
      def set_user
        @user = User.find(params[:id])
      end
  end
end
