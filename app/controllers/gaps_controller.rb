class GapsController < ApplicationController
  def index
  end

  def authentication_check
	authenticate_or_request_with_http_basic do |user, password|
	user == USER && password == PASSWORD
	end
  end

end
