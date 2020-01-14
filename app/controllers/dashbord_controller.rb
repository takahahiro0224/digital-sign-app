class DashbordController < ApplicationController
  before_action :login_check

  def index
  end

  protected

  def login_check
    unless user_signed_in?
      flash[:alert] = "ログインしてください"
      redirect_to root_path
    end
  end

end
