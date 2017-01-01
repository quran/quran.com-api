Raven.configure do |config|
  config.dsn = ENV['RAVEN_DSN']
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = ['staging', 'production']

  config.async = lambda { |event|
    SentryWorker.perform_async(event.to_hash)
  }
end