# frozen_string_literal: true

Rails.application.config.hosts += [
  '.quran.com',
  '.qurancdn.com',
  '.quran.foundation',
  '.staging.quran.foundation',
  '.ondigitalocean.app',
  '.quranreflect.com',
  '.quranreflect.org',
]

if Rails.env.development?
  Rails.application.config.hosts +=['.loca.lt', /.ngrok.io/, 'localhost']
end
