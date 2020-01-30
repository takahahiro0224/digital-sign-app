module Api
  class FriendsController < ApplicationController
    before_action :set_user
    before_action :set_friend, only: [:show, :update]

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end

    def index
      friends = @user.friends
      render json: friends
    end

    # {id: , name:, email: ,description:, credit_score:, charge_count:, charge_paid_cnt:,  ,paid_in_time_rate }
    def show
      res = @friend.attributes
      res['charge_cnt'] = @friend.charges.size
      paid_charges = @friend.charges.select{|charge| charge.paid }
      res['charge_paid_cnt'] = paid_charges.size
      if res['charge_paid_cnt'] > 0
        res['paid_in_time_rate'] =  (paid_charges.select{|charge| !charge.late}.size / res['charge_paid_cnt'] * 100).floor
      else
        res['paid_in_time_rate'] = nil
      end

      action_res = []
      @friend.charges.each do |charge|
        charge.charge_actions.each do |action|
          response = action.charge_action_response
          if response
            r = action.charge_action_response.attributes
            bill_id = action.charge.bill.id
            r['bill_id'] = bill_id

            action_res << r
          end
        end
      end
      
      action_res = action_res.empty? ? action_res : action_res.sort_by{|r| r["created_at"] }.reverse
      res['actions'] = action_res

      render json: res.to_json
    end

    def create
      @friend = @user.friends.new(friend_params)
      if @friend.save
        render json: @friend, status: :created
      else
        render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @friend.update(friend_params)
        head :no_content
      else
        render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
      end
    end

    protected

      def set_user
        @user = User.where(id: params[:user_id]).first
      end

      def set_friend
        @friend = @user.friends.where(id: params[:id]).first
      end
      
      def friend_params
        params.require(:friend).permit(:id, :user_id, :name, :email, :description)
      end

  end
end
