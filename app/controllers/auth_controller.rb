class AuthController < ApplicationController
  skip_before_action :set_user

  def callback
    data = request.env['omniauth.auth']
    render json: data.to_json
  end
end
