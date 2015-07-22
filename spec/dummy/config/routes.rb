
include Places

Rails.application.routes.draw do

  resources :people
  resources :people
  resources :people
  mount Places::Engine => "/places"

#  get 'place/create' => 'places#new', as: 'create'
#  post 'places/index' => 'places#create'
#  patch ':id' => 'places#update'
# could these really be removed to avoid providing access?? THIS NEEDS A LOOK
#  get 'place/addchild/:id' => 'places#addchild', as: 'place_addchild'
#  get 'place/remchild/:id' => 'places#remchild', as: 'place_remchild'
#  get 'place/breakparent/:id' => 'places#breakparent', as: 'place_breakparent'
#  get 'place/:id' => 'places#show', as: 'place'
#  get 'child/:id' => 'places#child', as: 'child'
#  get 'edit/:id' => 'places#edit', as: 'edit'

  get 'places/breakparent/:id' => 'places#breakparent', as: 'place_breakparent'
  get 'places/addchild/:id' => 'places#addchild', as: 'place_addchild'
  get 'places/remchild/:id' => 'places#remchild', as: 'place_remchild'

  root to: 'places#index'

  resources :places
end
