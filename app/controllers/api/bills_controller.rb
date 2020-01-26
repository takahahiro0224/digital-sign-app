module Api
  class BillsController < ApplicationController
    before_action :set_user
    before_action :set_bill, only: [:show, :update, :destroy, :send_mail, :sent_mails]

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
      
      res.store("friends", friends_name)
      res.store("category_i18n", @bill.category_i18n)
      res.store("price_format", @bill.price.format)
      render json: res
    end

    # メール送信履歴を降順に返す
    def sent_mails
      res = []
      @bill.charges.each do |charge|
        friend_name = charge.friend.name
        actions = charge.charge_actions
        next if actions.empty?

        actions.map(&:attributes).each do |ca|
          ca["friend_name"] = friend_name
          res << ca
        end
      end
      response = res.empty? ? res : res.sort_by{|r| r["created_at"] }.reverse

      render json: response
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

    # TODO: charge_actionの取り出し方を変える
    def send_mail
      @bill.charges.each do |charge|
        charge.charge_actions.new(action_type: 'notice').save
        charge_action = charge.charge_actions.last
        NotificationMailer.send_mail_to_friend(charge.friend, @bill, charge_action).deliver
      end
      render json: { status: "ok" }
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
        params.require(:bill).permit(:id, :user_id, :category, :description, :price_cents, :currency, :payment_due_date, :paid, :created_at, :updated_at)
      end
  end
end
