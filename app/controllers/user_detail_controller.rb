class UserDetailController < ApplicationController
  include GraphHelper

  def index
    @keys = %w(
      businessPhones
      displayName
      givenName
      jobTitle
      mail
      mobilePhone
      officeLocation
      preferredLanguage
      surname
      userPrincipalName
    )
    @user_detail = make_api_call("GET", "/v1.0/me", access_token)
    rescue RuntimeError => e
      @errors = [
        {
          message: "Microsoft Graph returned an error getting user info",
          debug: e
        }
      ]
  end
end
