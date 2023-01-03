Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :public do
    root "homes#top"
  end

  namespace :admin do
    root "homes#top"
  end
end
