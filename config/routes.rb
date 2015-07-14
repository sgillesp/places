Places::Engine.routes.draw do
  get 'index' => 'places#index', as: 'places'
  get 'create' => 'places#new', as: 'create'
  post 'index' => 'places#create'

  root :to => 'places#index'

  resources :places

end
