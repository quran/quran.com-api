Types::VerseType = GraphQL::ObjectType.define do
  name 'Verse'

  backed_by_model :verse do
    attr :id
    attr :chapter_id
    attr :verse_number
    attr :verse_index
    attr :verse_key
    attr :text_madani
    attr :text_indopak
    attr :text_simple
    attr :juz_number
    attr :hizb_number
    attr :rub_number
    attr :sajdah
    attr :sajdah_number
    attr :page_number
    attr :image_url
    attr :image_width
    attr :verse_root_id
    attr :verse_lemma_id
    attr :verse_stem_id

    has_one :chapter
    has_one :verse_root
    has_one :verse_lemma
    has_one :verse_stem
    has_many_array :tafsirs
    has_many_array :words

    field :translations, types[Types::TranslationType] do
      argument :resource_content_id, types[types.ID]
      resolve ->(verse, args, _ctx) { verse.translations.where(resource_content_id: args[:resource_content_id]) }
    end

    # If you want to add language support
    # Language.all.each do |language|
    #   field "#{language.iso_code}_language".to_sym, Types::TranslationType do
    #     resolve ->(obj, args, _ctx) { obj.translations.send("#{language.iso_code}_language") }
    #   end
    # end
  end
end
