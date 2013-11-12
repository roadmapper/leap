class GapsController < ApplicationController
  def index
    @property = Property.where(:owner_name => "Vinay")
  end

  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

end
