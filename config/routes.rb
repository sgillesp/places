Places::Engine.routes.draw do
  get 'index' => 'places#index', as: 'places'
  get 'create' => 'places#new', as: 'create'
  post 'index' => 'places#create'
  get ':id/edit' => 'places#edit', as: 'edit_place'
  patch ':id' => 'destinations#update'

  root :to => 'places#index'

  resources :places

end
