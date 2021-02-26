class ApplicationController < ActionController::Base
  def save_in_session(auth_hash)
    session[:graph_token_hash] = auth_hash[:credentials]
    session[:user_name] = auth_hash.dig(:extra, :raw_info, :displayName)
  end
end
