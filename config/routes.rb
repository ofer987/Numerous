Numerous::Application.routes.draw do
  resources :recipes do
    resources :ingredients
  end

  resources :place_types

  resources :destinations, only: [:index]

  resources :countries do
    resources :cities do
      resources :places do
        resources :websites
        resources :contacts
      end
    end
  end

  resources :countries do
    scope module: 'locationable' do
      resources :countries, as: 'locations'
    end
  end

  resources :cities do
    scope module: 'locationable' do
      resources :cities, as: 'locations'
    end
  end

  resources :places do
    scope module: 'locationable' do
      resources :places, as: 'locations'
    end
  end

  # These should be removed and accessed using a different controller
  resources :tag_links

  controller :stories do
    get 'stories/:article_id/new_photo' => :new_photo
    get 'stories/new_billet' => :new_billet
    post 'stories' => :create_billet
    post 'stories/:article_id/create_photo' => :create_photo
  end

  resources :articles do
    resources :comments, only: :create
  end

  resources :billets

  controller :articles do
    post 'articles/:article_id/create_photo' => :create_photo
  end

  # resources :articles do
  #   resources :comments
  # end

  get "books/read"

  resources :tags

  get "admin" => "admin#index"

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  resources :users

  controller :photos do
    patch 'photos/:id/rotate_clockwise' => :rotate_clockwise
  end

  resources :photos do
    resources :comments, only: :create
  end

  get "cv" => "curriculum#index"

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
  root :to => 'billets#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
