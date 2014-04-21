Public::Application.routes.draw do

  resources :property_measures


  resources :installed_measure_types


  resources :record_lookups
  
  #user authentication with devise, registration, and delete paths
  devise_for :users, :controllers => {:registrations => "newusers", :destroy => "newusers"}
  devise_scope :user do
  authenticated :user do
       root :to =>'dashboard#index'
	end
    unauthenticated :user do
	root :to => 'devise/sessions#new'
   end
  end

  resources :recordings
  resources :properties
  
  #user registration paths
  resources :newusers
  resources :users

  get "dashboard/property_report"

  get "dashboard/prism_report_electric"
  get "dashboard/prism_report_gas"
  post '/uploads/upload' => 'uploads#upload'
  post '/uploads/uploadGas' => 'uploads#uploadGas'
  resources :dashboard


  
  
  post '/stagings/insert' => 'stagings#insert'
  post '/stagings/insert' => 'stagings#destroyAll'
  resources :stagings do
	collection do
    		put :update_attribute_on_the_spot
    		get :get_attribute_on_the_spot
  	end
  end

  get 'analysis', to: 'analysis#index'
  get 'analysis/null_accounts'
  get 'analysis/dominion_ready_accounts'
  get 'analysis/dominion_ready_accounts_prism'
  get 'analysis/cvillegas_ready_accounts'
  get 'analysis/cvillegas_ready_accounts_prism'
  get 'analysis/washingtongas_ready_accounts'
  get 'analysis/washingtongas_ready_accounts_prism'

  get 'filtering', to: 'filtering#index'
  match '/filtering_reset' => 'filtering#reset', :as=>'reset'
  get "filtering/prism_report_electric", :defaults=> {format: 'csv'}
  get "filtering/prism_report_gas", :defaults=> {format: 'csv'}


  get 'requests', to: 'requests#index'
  get 'requests/dominion_request_accounts'
  get 'requests/cvillegas_request_accounts'
  get 'requests/washingtongas_request_accounts'

  get 'uploads/stagings', to: 'stagings#index'
  resources :uploads do
	member do
	    get :process
	end
  end

  root :to => "dashboard#index"



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
