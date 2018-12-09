Rails.application.routes.draw do
  resources :board_games, only: [:index] do
    collection do
      post :process_command
    end
  end

  root to: 'board_games#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
