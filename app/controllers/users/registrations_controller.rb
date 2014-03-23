class RegistrationsController < Devise::RegistrationsController
	before_filter :authenticate_scope!
end
