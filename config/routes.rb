
Places::Engine.routes.draw do
  resources :places

  get 'create' => 'places#new', as: 'create'
  post 'index' => 'places#create'
  patch ':id' => 'places#update'

  root :to => 'places#index'
end
