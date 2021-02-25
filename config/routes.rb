Rails.application.routes.draw do
  root to: "welcome#index"

  match "/auth/:provider/callback", :to => 'auth#callback', :via => [:get, :post]
end
