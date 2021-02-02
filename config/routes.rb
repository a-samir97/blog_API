Rails.application.routes.draw do
  
  post "users/login", to: "users#login"
  post "users/signup", to: "users#register"
  resources :posts do
    resources :comments
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end
