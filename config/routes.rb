Rails.application.routes.draw do
  #get "cart/show"
  #get "cart/checkout"
  #get "cart/purchase_history"
  get "cart/show", to: "cart#show", as: :cart
  get "cart/checkout", to: "cart#checkout", as: :checkout_cart
  get "cart/purchase_history", to: "cart#purchase_history", as: :purchase_history_cart
  #get 'reviews/user/:user_id', to: 'reviews#reviews_by_user', as: 'reviews_by_user'
  #get 'reviews/book/:book_id', to: 'reviews#reviews_by_book', as: 'reviews_by_book'
  get "home/index"
  root 'home#index'
  # llm helped with factoring out devise in general as I couldn't
  # get devise to work for having an Admin add a User
  devise_for :users, skip: [:registrations]
  resources :users

  # resources :users, only: [:index, :show, :edit, :update, :destroy]
  #resources :users, only: [:edit, :update]
  #resources :reviews
  resources :reviews do
    collection do
      get 'by_user', to: 'reviews#reviews_by_user', as: 'by_user'
      get 'by_book', to: 'reviews#reviews_by_book', as: 'by_book'
    end
  end

  resources :transactions
  #resources :books


  # /books/filter_by_rating → Calls the filter_by_rating action in BooksController.
  # /books/filter_by_author → Calls the filter_by_author action in BooksController.
  resources :books do
    collection do
      get :filter_by_rating  # Defines /books/filter_by_rating
      get :filter_by_author  # Defines /books/filter_by_author
    end
    member do
      post 'add_to_cart'    # Route for adding a book to the cart
      post 'remove_from_cart' # Route for removing a book from the cart
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :cart do
    post 'checkout'         # Route for checking out the cart
    get 'purchase_history'  # Route for viewing purchase history
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # Adding below routes for filter byy author and rating.

  # Admin namespace for review management
  namespace :admin do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy, :index, :show] do
      collection do
        get 'list_reviews_by_user'  # Admin-specific route to list reviews by user
        get 'list_reviews_by_book'  # Admin-specific route to list reviews by book
      end
    end
  end
  resources :books do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end
  # root "posts#index"
end
