# frozen_string_literal: true
class ActionDispatch::Routing::Mapper
  def draw_routes(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes", "#{@scope[:shallow_prefix]}", "#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  # NOTE: Normally we'd hide this in `Rails.env.development?` but having
  # anyone access it to play with API is a good tool

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

  namespace :api, defaults: {format: :json} do
    draw_routes :v3
    draw_routes :v4
  end

  root to: 'v3/ping#ping'
  get '/v3/ping', to: 'v3/ping#ping'

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
