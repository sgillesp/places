Places::Engine.routes.draw do
  get 'index' => 'places#index', as: 'places'
  get 'show' => 'places#show'
  get 'create' => 'places#new', as: 'places_create'

  resources :places

end
