
Places::Engine.routes.draw do
  resources :places

  get 'create' => 'places#new', as: 'create'
  post 'index' => 'places#create'
  patch ':id' => 'places#update'
  # these could really be removed to avoid providing access?? THIS NEEDS A LOOK
  get 'place/addchild/:id' => 'places#addchild', as: 'place_addchild'
  get 'place/remchild/:id' => 'places#remchild', as: 'place_remchild'
  get 'place/breakparent/:id' => 'places#breakparent', as: 'place_breakparent'
  get 'child/:id' => 'places#child', as: 'child'

  root :to => 'places#index'
end
