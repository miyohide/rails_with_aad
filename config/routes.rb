Rails.application.routes.draw do
  get 'user_detail/index'
  root to: "welcome#index"

  match "/auth/:provider/callback", :to => 'auth#callback', :via => [:get, :post]
  get "auth/signout"
end
