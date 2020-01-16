module Api
  class BillsController < ApplicationController
    before_action :set_user
    before_action :set_bill, only: [:show]

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end

    def index
      bills = @user.bills
      render json: bills
    end

    def show
      render json: @bill
    end

    def create
      @bill = @user.bills.build(bill_params)
      if @bill.save
        render json: @bill, status: :created
      end

    end

    protected

      def set_user
        @user = User.where(id: params[:user_id]).first
      end

      def set_bill
        @bill = @user.bills.where(id: params[:id]).first
      end

      def bill_params
        params.require(:bill).permit(:title, :description, :user, :price_cents, :currency, :paid)
      end
  end
end
