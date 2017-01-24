# == Schema Information
#
# Table name: translations
#
#  id                  :integer          not null, primary key
#  language_id         :integer
#  text                :string
#  resource_content_id :integer
#  resource_type       :string
#  resource_id         :integer
#  language_name       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Translation < ApplicationRecord
  include LanguageFilterable

  belongs_to :resource, polymorphic: true
  belongs_to :resource_content
  has_many :foot_notes, as: :resource

  def as_indexed_json(options)
    hash = self.as_json(
        only: [:id, :verse_key, :text_madani, :text_indopak, :text_simple],
        methods: [:chapter_name]
    )

    #translations.joins(:language).each do |trans|
    #  hash["trasn_#{trans.language.iso_code}"] = trans.text
    #end

    hash
  end

  indexes :translations, type: 'nested' do
    languages = Translation.where(resource_type: 'Verse').pluck(:language_id).uniq
    available_languages = Language.where(id: languages)

    available_languages.each do |lang|
      es_analyzer = lang.es_analyzer_default.present? ? lang.es_analyzer_default : nil

      indexes "trasn_#{lang.iso_code}", type: 'text' do
        indexes :text,
                type: 'text',
                similarity: 'my_bm25',
                term_vector: 'with_positions_offsets_payloads',
                analyzer: es_analyzer || 'standard'
        indexes :stemmed,
                type: 'text',
                similarity: 'my_bm25',
                term_vector: 'with_positions_offsets_payloads',
                analyzer: es_analyzer || 'english'
        indexes :shingles,
                type: 'text',
                similarity: 'my_bm25',
                term_vector: 'with_positions_offsets_payloads',
                analyzer: 'shingle_analyzer'
        indexes :autocomplete,
                type: 'text',
                analyzer: 'autocomplete',
                search_analyzer: 'standard',
                index_options: 'offsets'
      end
    end
  end

end
