Apipie.configure do |config|
  config.app_name                = "QuranAPI"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/docs"
  config.default_version         = "2.0"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/{[!concerns/]**/*,*}.rb"
end
