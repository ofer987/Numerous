Numerous::Application.routes.draw do
  get "frontpages/index"

  # These should be removed and accessed using a different controller
  resources :tag_links

  controller :stories do
    get 'stories/:article_id/new_photo' => :new_photo
    get 'stories/new_article' => :new_article
    post 'stories' => :create_article
    post 'stories/:article_id/create_photo' => :create_photo
  end

  scope ':username', as: :user do
    resources :articles do
      resources :comments, only: :create
    end

    resources :admin, only: :index
  end

  controller :articles do
    post 'articles/:article_id/create_photo' => :create_photo
  end

  resources :tags

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  controller :photos do
    patch 'photos/:id/rotate_clockwise' => :rotate_clockwise
  end

  resources :photos do
    resources :comments, only: :create
  end

  root :to => 'frontpages#index'
end
