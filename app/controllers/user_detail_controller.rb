require 'graph_helper'

class UserDetailController < ApplicationController

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
    @user_detail = ::GraphHelper.make_api_call("GET", "/v1.0/me", access_token)
    rescue RuntimeError => e
      @errors = [
        {
          message: "Microsoft Graph returned an error getting user info",
          debug: e
        }
      ]
  end
end
