module Api
  class BillsController < ApplicationController
    before_action :set_user
    before_action :set_bill, only: [:show, :update, :destroy, :send_mail]

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end

    def index
      bills = @user.bills.select(:id, :price_cents, :payment_due_date, :category)
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
      res = @bill.attributes
      friends = get_friends(@bill)
      friends_name = friends.map(&:name)
      
      res.store("debtor", friends_name)
      res.store("category_i18n", @bill.category_i18n)
      render json: res
    end

    # Post params: {'bill': {...}, 'friends': [...]}
    def create
      ActiveRecord::Base.transaction do
        @bill = @user.bills.new(bill_params)
        @bill.save!
        friend_params.each do |id|
          @debtor = Debtor.new(bill_id: @bill.id, friend_id: id)
          @debtor.save!
        end
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

    def send_mail
      friends = get_friends(bill)
      friends.each do |friend|
        NotificationMailer.send_mail_to_debtor(friend, @user, @bill).deliver
      end
    end

    protected

      def get_friends(bill)
        friend_ids = @bill.debtor.map(&:friend_id)
        Friend.where(id: friend_ids)
      end

      def set_user
        @user = User.where(id: params[:user_id]).first
      end

      def set_bill
        @bill = @user.bills.where(id: params[:id]).first
      end

      def friend_params
        params.require(:friends)
      end

      def bill_params
        params.require(:bill).permit(:id, :user_id, :category, :description, :price_cents, :currency, :payment_due_date, :paid)
      end
  end
end
