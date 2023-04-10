# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users do
    member do
      put :location
    end
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

  get 'reports/infected_percentage'
  get 'reports/non_infected_percentage'
  get 'reports/average_items_per_user'
  get 'reports/lost_points'
end
