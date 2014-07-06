class OptionsController < ApplicationController
    def default
    end

    def language
        
        @results = Content::Resource
        .joins(:language, :_resource_api_version)
        .select("i18n.language.language_code,i18n.language.unicode, i18n.language.english, i18n.language.direction")
        .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.is_available = 't'")
        .group("i18n.language.language_code, i18n.language.unicode, i18n.language.english, i18n.language.direction")
        .order("i18n.language.language_code")

        # Content::Resource.joins(:language, :_resource_api_version).select(i18n: {language: :language_code})
    end

    def quran

        @results = Content::Resource
        .joins(:_resource_api_version)
        .select([:resource_id, :sub_type, :cardinality_type, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
        .where("content.resource.type = 'quran' AND content.resource_api_version.v2_is_enabled = 't'")

        
    end

    def content

        @results = Content::Resource
        .joins(:_resource_api_version)
        .select([:resource_id, :sub_type, :cardinality_type, :language_code, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
        .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.type = 'content'")
        

        
    end

    def audio


        @results = Audio::Recitation
        .joins(:reciter).joins("LEFT JOIN audio.style using ( style_id )")
        .select([:recitation_id, :reciter_id, :style_id].map{ |term| "audio.recitation.#{term}" }.join(', ') + ", audio.style.slug AS style_slug, audio.reciter.slug AS reciter_slug, concat_ws( ' ', audio.reciter.english, case when ( audio.style.english is not null ) then concat( '(', audio.style.english, ')' ) end ) name_english, concat_ws( ' ', audio.reciter.arabic, case when ( audio.style.arabic is not null ) then concat( '(', audio.style.arabic, ')' ) end ) name_arabic")
        .where("audio.recitation.is_enabled = 't'")
        .order("audio.reciter.english, audio.style.english, audio.recitation.recitation_id")

        
    end
end
