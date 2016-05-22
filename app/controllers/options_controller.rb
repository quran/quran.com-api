class OptionsController < ApplicationController
  # caches_page :default, :language, :quran, :content, :audio
  caches_action :default, :language, :quran, :content, :audio
  def default
    @results = {content: [21], quran: 1, audio: 1, url: "?content=217&quran=1&audio=1"}
  end

  api :GET, '/options/language'
  def language
    @results = Rails.cache.fetch('list_language_options', expires_in: 12.hours) do
      Content::Resource.list_language_options
    end
  end

  api :GET, '/options/quran'
  def quran
    @results = Rails.cache.fetch('list_quran_options', expires_in: 12.hours) do
      Content::Resource.list_quran_options
    end
  end

  api :GET, '/options/content'
  def content
    @results = Rails.cache.fetch('list_content_options', expires_in: 12.hours) do
      Content::Resource.list_content_options
    end
  end

  api :GET, '/options/audio'
  def audio
    @results = Rails.cache.fetch('list_audio_options', expires_in: 12.hours) do
      Audio::Recitation.list_audio_options
    end
  end
end
