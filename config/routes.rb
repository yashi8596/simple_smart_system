Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :public do
    root to: "homes#top"
    resource :sessions, only:[:new, :create, :destroy]
  end

  namespace :admin do
    root "homes#top"
    resource :sessions, only:[:new, :create, :destroy]
  end
end
