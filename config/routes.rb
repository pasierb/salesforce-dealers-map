Rails.application.routes.draw do
  root to: "dealers#index"

  resources :dealers
end
