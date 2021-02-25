require 'microsoft_graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :microsoft_graph_auth,
           Rails.application.credentials.azure_app_id,
           Rails.application.credentials.azure_app_secret,
           :scope => Rails.application.credentials.azure_scopes
end
