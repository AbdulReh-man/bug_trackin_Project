Rails.application.routes.draw do
  
  root "main_page#index"
  devise_for :users

  devise_scope :user do
      get "users/sign_out", to: "devise/sessions#destroy"
      delete '/users/delete_with_projects', to: 'users#destroy_with_projects', as: :custom_user_destroy
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
  get "error" =>  "errors#show", as: :error_display



  # API routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      devise_scope :user do
        # post 'users/sign_up', to: 'registrations#create'
        # delete 'users/sign_out', to: 'sessions#destroy'
        # post 'users/sign_in', to: 'sessions#create'
        delete 'users/destroy_with_projects', to: 'users#destroy_with_projects'
      end

      # Projects API routes
      resources :projects, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :assign_users
          get :assign_users
          get :view_users
          delete :remove_user
        end

        # Bugs API routes
        resources :bugs, only: [:index, :show, :create, :update, :destroy] do
          member do
            patch :mark_done
            patch :assign_user
          end
        end
      end
      
    end
  end

end
