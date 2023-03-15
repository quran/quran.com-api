# frozen_string_literal: true
class ActionDispatch::Routing::Mapper
  def draw_routes(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes", "#{@scope[:shallow_prefix]}", "#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  # NOTE: Normally we'd hide this in `Rails.env.development?` but having
  # anyone access it to play with API is a good tool
  # mount GraphQL::Playground::Engine, at: "/graphql-playground", graphql_path: "/graphql"
  post '/graphql', to: 'graphql#execute'
  post "/internal/sync_api_client", to: "api_clients#sync"

  namespace :kalimat do
    get '/search', to: 'search#search'
    get '/suggest', to: 'search#suggest'
  end

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

  namespace :api, defaults: {format: :json} do
    draw_routes :qdc
    draw_routes :v4
    draw_routes :v3
  end

  root to: 'api/v4/ping#ping'
end
