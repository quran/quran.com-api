class V2::OptionsController < ApplicationController
  #caches_action :default, :language, :quran, :content, :audio
  def default
    render json: {content: [21], quran: 1, audio: 1, url: "?content=217&quran=1&audio=1"}
  end

  def language
    options = Rails.cache.fetch('v2_list_language_options', expires_in: 12.hours) do
      Content::Resource.list_language_options
    end

    render json: options
  end

  def quran
    options = Rails.cache.fetch('v2_list_quran_options', expires_in: 12.hours) do
      Content::Resource.quran.enabled.map(&:view_json)
    end

    render json: options
  end

  def content
    options = Rails.cache.fetch('v2_list_content_options', expires_in: 12.hours) do
      Content::Resource.content.enabled.map(&:view_json)
    end

    render json: options
  end

  def audio
    options = Rails.cache.fetch('v2_list_audio_options', expires_in: 12.hours) do
      Audio::Recitation.where(is_enabled: true)
    end

    render json: options
  end

end
