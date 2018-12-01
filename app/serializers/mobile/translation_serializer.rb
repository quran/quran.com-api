module Mobile
  class TranslationSerializer <  ActiveModel::Serializer
    attribute :id do
      object.mobile_translation_id
    end

    attribute :displayName do
      object.localized_name.presence || object.name
    end

    attribute :translator do
      object.author_name
    end

    attribute :languageCode do
      object.language.iso_code
    end

    attribute :fileUrl do
      "https://mobile.qurancdn.com/mobile/translations/#{object.mobile_translation_id}/download"
    end

    attribute :fileName do
      "#{object.slug}.db"
    end

    attribute :saveTo do
      'databases'
    end

    attribute :downloadType do
      'translation'
    end

    attribute  :minimum_version do
      1
    end

    attribute :current_version do
       object.updated_at.to_i
    end

    attribute :enabled do
      1
    end
  end
end