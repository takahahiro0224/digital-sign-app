module Api
  class BillsController < ApplicationController
    before_action :set_user
    before_action :set_bill, only: [:show, :update, :destroy]

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end

    def index
      bills = @user.bills.select(:id, :title, :price_cents)
      res = bills.all.map {|bill| bill.attributes}
      res.each do |h|
        friend_id = Bill.find(h["id"]).debtor&.first&.friend_id
        friend_name = ""
        if friend_id
          friend_name = Friend.find(friend_id).name
        end
        h.store("debtor", friend_name)
      end
      render json: res.to_json
    end


    # billとdebtorを組み合わせて返す
    def show
      debtor_name = @bill.debtors&.first.name
      render json: @bill
    end

    # Post params: {'bills': { }, 'friend':{ }}
    def create
      ActiveRecord::Base.transaction do
        @bill = @user.bills.new(bill_params)
        @bill.save!
        @friend = @user.friends.new(friend_params)
        @friend.save!
        @debtor = Debtor.new(bill_id: @bill.id, friend_id: @friend.id)
        @debtor.save!
      end
      render json: @bill, status: :created
    rescue
      render json: { errors: @bill.errors.full_messages }, status: :unprocessable_entity
    end

    def update
      if @bill.update(bill_params)
        head :no_content
      else
        render json: { errors: @bill.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @bill.destroy!
      head :no_content
    end

    protected

      def set_user
        @user = User.where(id: params[:user_id]).first
      end

      def set_bill
        @bill = @user.bills.where(id: params[:id]).first
      end

      def friend_params
        params.require(:friend).permit(:id, :user_id, :name, :email, :description)
      end

      def bill_params
        params.require(:bill).permit(:id, :user_id, :title, :description, :price_cents, :currency, :paid)
      end
  end
end
