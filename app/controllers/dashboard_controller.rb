class DashboardController < ApplicationController
  def index
    @property = Property.where(:owner_name => "Vinay")
  end

end
