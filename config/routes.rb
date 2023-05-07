Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: :public do
    root to: "homes#top"
    resource :session, only:[:new, :create, :destroy]
    resource :employee, only:[:edit, :update]
    patch "employee/paid_leave_update" => "employees#paid_leave_update", as: "paid_leave_update" #有給残日数の更新
    resources :leave_requests, except:[:index, :destroy]
    get "leave_requests/:id/cancel" => "leave_requests#cancel", as: "cancel"
    patch "leave_requests/:id/cancel" => "leave_requests#cancel_update", as: "cancel_update" #申請取り消し用
    resources :salaries, only:[:show, :index]
    resource :password, only:[:edit, :update]
    resources :time_records, only:[:create, :index, :update]
  end

  namespace :admin do
    root "homes#top"
    resource :session, only:[:new, :create, :destroy]
    resources :employees
    get "employees/:id/confirm" => "employees#confirm", as: "confirm" #従業員データ物理削除時の確認用画面
    resources :salaries, except:[:destroy]
    resources :leave_requests, except:[:new, :show, :create, :destroy]
    get "leave_requests/:id/cancel" => "leave_requests#cancel", as: "cancel"
    patch "leave_requests/:id/cancel" => "leave_requests#cancel_update", as: "cancel_update"
    resources :time_records, only:[:edit, :index, :update]
  end
end