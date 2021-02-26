require 'microsoft_graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph_auth,
           Rails.application.credentials.azure_app_id,
           Rails.application.credentials.azure_app_secret,
           :scope => 'openid profile offline_access user.read'
end
