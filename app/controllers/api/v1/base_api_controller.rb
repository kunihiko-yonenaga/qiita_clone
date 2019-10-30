class Api::V1::BaseApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  def loggedinuser
    @current_user = user.first
  end
end
