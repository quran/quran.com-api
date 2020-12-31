# frozen_string_literal: true

Rails.application.config.hosts += [
  '.quran.com',
  '.qurancdn.com',
  'localhost'
]

if Rails.env.development?
  Rails.application.config.hosts << '.loca.lt'
end
