class UserDetailController < ApplicationController
  include GraphHelper

  def index
    @user_detail = make_api_call("GET", "/v1.0/me", access_token)
    render json: @user_detail
    rescue RuntimeError => e
      @errors = [
        {
          message: "Microsoft Graph returned an error getting user info",
          debug: e
        }
      ]
  end
end
