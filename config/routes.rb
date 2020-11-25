Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html


  post '/user/create', to: 'user#create'

  post '/short_url', to: 'url#short'
  get '/s/:short_code', to: 'url#redirect', as: :short
  get '/domains', to: 'url#domains'
  get '/get_by_domain/:domain', to: 'url#get_by_domain'
end
