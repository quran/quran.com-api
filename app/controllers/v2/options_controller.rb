class V2::OptionsController < ApplicationController
  caches_action :default, :language, :quran, :content, :audio
  def default
    render json: {content: [21], quran: 1, audio: 1, url: "?content=217&quran=1&audio=1"}
  end

  api :GET, '/options/language', 'List of all language options'
  api_version '2.0'
  def language
    options = Rails.cache.fetch('v2_list_language_options', expires_in: 12.hours) do
      Content::Resource.list_language_options
    end

    render json: options
  end

  api :GET, '/options/quran', 'List of all Quran rendering'
  api_version '2.0'
  def quran
    options = Rails.cache.fetch('v2_list_quran_options', expires_in: 12.hours) do
      Content::Resource.quran.enabled.map(&:view_json)
    end

    render json: options
  end

  api :GET, '/options/content', 'List of all content translations'
  api_version '2.0'
  def content
    options = Rails.cache.fetch('v2_list_content_options', expires_in: 12.hours) do
      Content::Resource.content.enabled.map(&:view_json)
    end

    render json: options
  end

  api :GET, '/options/audio', 'List of all reciters'
  api_version '2.0'
  def audio
    options = Rails.cache.fetch('v2_list_audio_options', expires_in: 12.hours) do
      Audio::Recitation.where(is_enabled: true)
    end

    render json: options
  end

end
