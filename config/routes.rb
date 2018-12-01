# frozen_string_literal: true

Rails.application.routes.draw do

  # NOTE: Normally we'd hide this in `Rails.env.development?` but having
  # anyone access it to play with API is a good tool
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'

  post '/graphql', to: 'graphql#execute'

  namespace :v3 do
    get 'audio_files/index'
  end


  namespace :mobile do
    resources :translations, only: :index do
      member do
        get :download
      end
    end
  end

  scope :api do
    namespace :v3 do
      resources :foot_notes, only: :show, defaults: { format: 'json' }

      resources :chapters, only: [:index, :show], defaults: { format: 'json' } do
        member do
          get :info, to: 'chapter_infos#show'
        end

        resources :verses, only: [:index, :show], defaults: { format: 'json' } do
          resources :tafsirs, only: [:index], defaults: { format: 'json' }
          resources :translations, only: [:index], defaults: { format: 'json' }
          resources :audio_files, only: [:index], defaults: { format: 'json' }
        end
      end

      resources :juzs, only: [:show, :index], defaults: { format: 'json' }
      resources :pages, only: [:show], defaults: { format: 'json' }
      resources :words, only: [:show], defaults: { format: 'json' }

      namespace :options, defaults: { format: 'json' } do
        get :default
        get :translations
        get :recitations
        get :tafsirs
        get :languages
        get :media_content
        get :chapter_info
      end

      get 'search', to: 'search#index'
      get 'suggest', to: 'suggest#index'
    end
  end

  root to: 'v3/ping#ping'
  get '/ping', to: 'v3/ping#ping'

  ['sitemap.xml.gz', 'sitemap:number.xml.gz'].each do |path|
    get "/sitemaps/#{path}" => proc { |req|
      filename = req['PATH_INFO'].gsub('sitemaps', '').gsub(/\//, '')

      [
        200,
        {
          'Pragma'        => 'public',
          'Cache-Control' => "max-age=#{1.day.to_i}",
          'Expires'       => 1.day.from_now.to_s(:rfc822),
          'Content-Type'  => 'text/html'
        },
        [open(Rails.root.join('public', 'sitemaps', filename)).read]
      ]
    }
  end
end
