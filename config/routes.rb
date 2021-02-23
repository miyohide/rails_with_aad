Rails.application.routes.draw do
  get 'oauths/oauth'
  get 'oauths/callback'
  root to: "welcome#index"
  resources :users

  post "oauth/callback" => "oauths#callback"
  get "/oauth/callback/microsoft" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
end
