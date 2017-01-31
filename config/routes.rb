Rails.application.routes.draw do
  scope :api do
    namespace :v3 do
      resources :chapters, only: [:index, :show], defaults: {format: 'json'} do
        member do
          get :info, to: 'chapter_infos#show'
        end

        resources :verses, only: [:index, :show], defaults: {format: 'json'} do
          resources :tafsirs, only: [:index], defaults: {format: 'json'}
        end
      end

      namespace :options, defaults: {format: 'json'} do
        get :default
        get :translations
        get :recitations
        get :tafsirs
        get :languages
        get :media_content
        get :chapter_info
      end
    end
  end

  root to: 'v3/ping#ping'
  get '/ping', to: 'v3/ping#ping'
end
