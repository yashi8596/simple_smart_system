Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :public do
    root to: "homes#top"
    resource :sessions, only:[:new, :create, :destroy]
    resource :employees, only:[:edit, :update]
    resources :leave_requests, only:[:new, :create, :update]
    get "requests/:id/cancel" => "requests#cancel", as: "cancel_request" #申請取り消し用
  end

  namespace :admin do
    root "homes#top"
    resource :sessions, only:[:new, :create, :destroy]
    resources :employees, except:[:index]
    get "employees/:id/confirm" => "employees#confirm", as: "confirm" #従業員データ物理削除時の確認用画面
    resources :salaries, except:[:destroy]
    resources :leave_requests, except:[:new, :create, :destroy]
  end
end
