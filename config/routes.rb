Rails.application.routes.draw do
  get '/nearest_gas', to: 'queries#nearest_gas'
end
