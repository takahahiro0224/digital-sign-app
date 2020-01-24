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
        friends = Bill.find(h["id"]).charges.map(&:friend)
        friend_names = friends.map(&:name)
        h.store("friends", friend_names)
      end
      render json: res.to_json
    end


    # billとfriendを組み合わせて返す
    def show
      res = @bill.attributes
      friends = @bill.charges.map(&:friend)
      friends_name = friends.map(&:name)
      @bill.charges.each do |charge|
        charge.friend
        actions = charge.charge_actions
      end
      
      res.store("friends", friends_name)
      res.store("category_i18n", @bill.category_i18n)
      res.store("price_format", @bill.price.format)
      render json: res
    end

    # Post params: {'bill': {...}, 'friends': [...]}
    def create
      ActiveRecord::Base.transaction do
        @bill = @user.bills.new(bill_params)
        @bill.save!
        friend_params.each do |id|
          @charge = Charge.new(bill_id: @bill.id, friend_id: id)
          @charge.save!
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
      @bill.charges.each do |charge|
        NotificationMailer.send_mail_to_friend(charge.friend, @bill).deliver
        charge.charge_actions.new(action_type: 'notice').save
      end
    end

    protected

      def get_friends(bill)
        @bill.charges.map(&:friend)
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
