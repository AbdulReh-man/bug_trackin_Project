Rails.application.routes.draw do
  root "main_page#index"
  devise_for :users
  
  devise_scope :user do
    get "users/sign_out", to: "devise/sessions#destroy"
  end
  
  resources :projects do
    member do
      post :assign_users
      get :assign_users
      get 'view_users'
      delete 'remove_user/:user_id', to: 'projects#remove_user', as: :remove_user
    end

    resources :bugs do
      member do
        patch :mark_done
        patch :assign_user
      end
    end
  end
  

  get "up" => "rails/health#show", as: :rails_health_check
end
