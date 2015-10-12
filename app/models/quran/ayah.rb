# vim: ts=4 sw=4 expandtab
class Quran::Ayah < ActiveRecord::Base
    extend Quran
    extend Batchelor

    self.table_name = 'ayah'
    self.primary_key = 'ayah_key'

    belongs_to :surah, class_name: 'Quran::Surah'

    has_many :words,  class_name: 'Quran::Word',  foreign_key: 'ayah_key'
    has_many :tokens, class_name: 'Quran::Token', through:     :words
    has_many :stems,  class_name: 'Quran::Stem',  through:     :words
    has_many :lemmas, class_name: 'Quran::Lemma', through:     :words
    has_many :roots,  class_name: 'Quran::Root',  through:     :words

    has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'ayah_key'
    has_many :tafsirs,      class_name: 'Content::Tafsir',     through:     :_tafsir_ayah

    has_many :translations,     class_name: 'Content::Translation',     foreign_key: 'ayah_key'
    has_one :transliteration, class_name: 'Content::Transliteration', foreign_key: 'ayah_key'

    has_many :audio,  class_name: 'Audio::File',     foreign_key: 'ayah_key'
    has_many :texts,  class_name: 'Quran::Text',     foreign_key: 'ayah_key'
    has_many :images, class_name: 'Quran::Image',    foreign_key: 'ayah_key'
    has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: 'ayah_key'

    # NOTE the relationships below were created as database-side views for use with elasticsearch
    has_many :text_roots,  class_name: 'Quran::TextRoot',  foreign_key: 'ayah_key'
    has_many :text_lemmas, class_name: 'Quran::TextLemma', foreign_key: 'ayah_key'
    has_many :text_stems,  class_name: 'Quran::TextStem',  foreign_key: 'ayah_key'
    has_many :text_tokens, class_name: 'Quran::TextToken', foreign_key: 'ayah_key'

    def self.get_ayahs_by_range(surah_id, from, to)
      self.where('quran.ayah.surah_id = ?', surah_id)
          .where('quran.ayah.ayah_num >= ?', from)
          .where('quran.ayah.ayah_num <= ?', to)
          .order('quran.ayah.surah_id, quran.ayah.ayah_num')
    end

    def self.get_ayahs_by_array(ayahs_keys_array)
      self.where(ayah_key: ayahs_keys_array)
          .sort{|e1, e2| ayahs_keys_array.index(e1.ayah_key) <=> ayahs_keys_array.index(e2.ayah_key)}
    end

    def self.get_ayahs_by_page(page)
      self.where(page_num: page)
          .order('quran.ayah.surah_id, quran.ayah.ayah_num')
    end

    def self.import_options ( options = {} )
        transform = lambda do |a|
            data = a.__elasticsearch__.as_indexed_json
            data.delete( 'text' ) # NOTE we exclude text because it serves no value in the parent mapping
            { index: { _id: "#{a.ayah_key}", data: data } }
        end
        options = { transform: transform, batch_size: 6236 }.merge( options )
        return options
    end

    def self.import ( options = {} )
        self.importing( self.import_options( options ) )
    end

    def self.merge_content(content_param = [], ayahs_array = [], keys = nil)
      keys ||= ayahs_array.map(&:ayah_key)

      Content::Resource.bucket_content(content_param, keys).each_with_index do |ayah_content, index|
        ayahs_array[index][:content] = ayah_content
      end
    end

    def self.merge_quran(quran_param, ayahs_array = [], keys = nil)
      keys ||= ayahs_array.map(&:ayah_key)

      Content::Resource.bucket_quran(1 || quran_param, keys).each_with_index do |ayah_quran, index|
        ayahs_array[index][:quran] = ayah_quran
      end
    end

    def self.merge_audio(audio_param, ayahs_array = [], keys = nil)
      keys ||= ayahs_array.map(&:ayah_key)

      Audio::File.bucket_audio(audio_param, keys).each_with_index do |ayah_audio, index|
        ayahs_array[index][:audio] = ayah_audio
      end
    end

    def self.merge_resource_with_ayahs(params = {}, ayahs)
      keys = ayahs.map(&:ayah_key)
      ayahs = ayahs.map(&:attributes)

      self.merge_quran(nil, ayahs, keys)

      # # Fetch the content corresponding to the the ayah keys and the content requested.
      if params[:content].present?
        self.merge_content(params[:content], ayahs, keys)
      end

      if params[:audio].present?
        self.merge_audio(params[:audio], ayahs, keys)
      end

      ayahs
    end
end
