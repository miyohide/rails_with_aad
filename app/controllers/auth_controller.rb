class AuthController < ApplicationController
  def callback
    data = request.env['omniauth.auth']
    render json: data.to_json
  end
end
