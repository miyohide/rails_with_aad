class ApplicationController < ActionController::Base
  before_action :set_user

  def save_in_session(auth_hash)
    session[:graph_token_hash] = auth_hash[:credentials]
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
  end

  def user_name
    session[:user_name]
  end

  def access_token
    session[:graph_token_hash][:token]
  end

  def set_user
    @user_name = user_name
  end
end
