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

    def self.fetch_ayahs(surah_id, from, to)
        self.where('quran.ayah.surah_id = ?', surah_id)
            .where('quran.ayah.ayah_num >= ?', from)
            .where('quran.ayah.ayah_num <= ?', to)
            .order('quran.ayah.surah_id, quran.ayah.ayah_num')
    end

    def self.fetch_ayahs_array(ayahs_keys_array)
      self.where(ayah_key: ayahs_keys_array)
    end

    def self.fetch_paged_ayahs(page)
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

    def self.get_ayat(params = {})
        results = Hash.new
        params[:quran] ||= 1

        # The range of which the ayahs to search
        if params.key?(:range)
            range = params[:range].split('-')
        elsif params.key?(:from) && params.key?(:to)
            range = [params[:from], params[:to]]
        else
            range = ['1', '10']
        end

        if params.key?(:ayah)
            range = [ params[:ayah] ]
        end

        # Error whenever the range is more than 50
        if (range.last.to_i - range.first.to_i) > 50
            return {error: "Range invalid, use a string (maximum 50 ayat per request), e.g. '1-3'"}
        end

        ayahs = Quran::Ayah.fetch_ayahs(params[:surah_id], range.first, range.last)

        keys = ayahs.map{|k| k.ayah_key}

        # For each key, need to setup the hash
        ayahs.each do |ayah|
            results["#{ayah.ayah_key}".to_sym] = Hash.new
            results["#{ayah.ayah_key}".to_sym][:ayah] = ayah.ayah_key.split(':').last.to_i
            results["#{ayah.ayah_key}".to_sym][:surah_id] = ayah.surah_id.to_i
            results["#{ayah.ayah_key}".to_sym][:text] = ayah.text
        end

        Content::Resource.bucket_results_quran(params[:quran], keys).each do |ayah|
            if ayah.kind_of?(Array)
                results["#{ayah.first[:ayah_key]}".to_sym][:quran] = ayah
            else
                results["#{ayah[:ayah_key]}".to_sym][:quran] = ayah
            end
        end

        # Fetch the content corresponding to the the ayah keys and the content requested.
        if !params[:content].nil?
            Content::Resource.bucket_results_content(params[:content], keys).each do |ayah|
                results["#{ayah.first[:ayah_key]}".to_sym][:content] = ayah
            end
        end

        if !params[:audio].nil?
            Audio::File.fetch_audio_files(params[:audio], keys).each do |ayah|
                results["#{ayah[:ayah_key]}".to_sym][:audio] = ayah
            end
        end

        results.values
    end
end
