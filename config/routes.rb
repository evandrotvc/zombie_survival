# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    resources :survivors, param: 'user_target_id' do
      member do
        post :infected, controller: :users
      end
    end
    resources :items do
      collection do
        post :add
        delete :remove
        post :trade
      end
    end
  end
end
