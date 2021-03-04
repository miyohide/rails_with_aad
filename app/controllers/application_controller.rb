require "microsoft_graph_auth"
require "oauth2"

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
    token_hash = session[:graph_token_hash]

    expiry = Time.at(token_hash[:expires_at] - 300)

    if Time.now > expiry
      new_hash = refresh_tokens token_hash
      new_hash[:token]
    else
      token_hash[:token]
    end
  end

  def set_user
    @user_name = user_name
  end

  def refresh_tokens(token_hash)
    oauth_strategy = OmniAuth::Strategies::MicrosoftGraphAuth.new(
      nil, Rails.application.credentials.azure_app_id,
      Rails.application.credentials.azure_app_secret
    )
    token = OAuth2::AccessToken.new(
      oauth_strategy.client, token_hash[:token],
      refresh_token: token_hash[:refresh_token]
    )
    new_tokens = token.refresh!.to_hash.slice(:access_token, :refresh_token, :expires_at)
    new_tokens[:token] = new_tokens.delete :access_token
    session[:graph_token_hash] = new_tokens
  end
end
