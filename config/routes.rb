Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'raw', action: :raw, controller: 'data'
  get 'map', action: :map, controller: 'data'
end
