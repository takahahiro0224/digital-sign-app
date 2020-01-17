class ApplicationController < ActionController::Base
  #include DeviseTokenAuth::Concerns::SetUserByToken
  #skip_before_action :verify_authenticity_token, if: :devise_controller? # APIではCSRFチェックをしない
  protect_from_forgery with: :null_session

  def after_sign_in_path_for(resource)
    dashbord_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

end
