class MailResponseController < ApplicationController
  before_action :set_charge_action, only: [:new, :create]

  def new
    if @charge_action.charge_action_response
      redirect_to '/done'
    end

    @charge = @charge_action.charge
    @bill = @charge.bill
    @username = @bill.user.username
  end

  def create
    response = ChargeActionResponse.new(param_to_int(response_params))
    response.charge_action = @charge_action
    if response.save
      redirect_to '/done'
    else
      render 'new'
    end
  end

  def done
  end


  private

    def set_charge_action
      @charge_action = ChargeAction.find_by(token: params[:token])
    end

    def response_params
      params.permit(:payment_ability, :comment)
    end

    # enum用に型変換
    def param_to_int(params)
      params.each do |key, value|
        if key == "payment_ability"
          params[key] = value.to_i
        end
      end
    end
end
