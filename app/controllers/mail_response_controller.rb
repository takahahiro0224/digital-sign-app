class MailResponseController < ApplicationController
  before_action :set_charge_action, only: [:new]

  def new
    @charge = @charge_action.charge
    @bill = @charge.bill
    @username = @bill.user.username
  end


  private
    def set_charge_action
      @charge_action = ChargeAction.find_by(token: params[:token])
    end
end
