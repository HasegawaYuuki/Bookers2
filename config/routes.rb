Rails.application.routes.draw do
  get 'groups/new'
  get 'groups/index'
  get 'groups/show'
  get 'groups/edit'
  devise_for :users
  root to: 'homes#top'
  get 'home/about' => 'homes#about',as: 'about'
  get "search", to: "searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :messages, only: [:show, :create, :destroy]
  resources :rooms, only: [:create, :show]
  resources :groups, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
    resource :group_users, only: [:create, :destroy]
  end

end
