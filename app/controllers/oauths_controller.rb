class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "Logged in from #{provider.titleize}!"
    else
      begin
        User.find_by(email: @user.email)
      rescue
        redirect_to root_path, notice: "Failed to login from #{provider.titleize}!"
      end
    end
  end

  private
  def auth_params
    params.permit(:code, :provider, :session_state)
  end
end
