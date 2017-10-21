if Rails.env.production? && ENV['SENTRY_DSN'].present?
  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.environments = ["production"]
  end
end