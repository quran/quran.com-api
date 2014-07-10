class Content::Resource < ActiveRecord::Base
    extend Content

    self.table_name = 'resource'
    self.primary_key = 'resource_id'
# Rails.logger.ap self.table_name

    self.inheritance_column = nil

    belongs_to :author, class_name: 'Content::Author'
    belongs_to :source, class_name: 'Content::Source'
    belongs_to :language, class_name: 'I18n::Language', foreign_key: 'language_code'

    # maybe make the block below a polymorphic class, accessible via 'content' or something
    # dunno wth polymorphic relationships really are, so maybe not -- fancy crap not worth a brain cell
    has_many :_image, class_name: 'Quran::Image', foreign_key: 'resource_id'
    has_many :_text, class_name: 'Quran::Text', foreign_key: 'resource_id'
    has_many :_word_font, class_name: 'Quran::WordFont', foreign_key: 'resource_id'
    has_many :_tafsir, class_name: 'Content::Tafsir', foreign_key: 'resource_id'
    has_many :_translation, class_name: 'Content::Translation', foreign_key: 'resource_id'
    has_many :_transliteration, class_name: 'Content::Transliteration', foreign_key: 'resource_id'
    has_one  :_resource_api_version, class_name: 'Content::ResourceAPIVersion', foreign_key: 'resource_id'


    # def category
    #     attr_reader :type
    # end
    def self.fetch_cardinalities(params)
        cardinality = Hash.new
        cardinality[:quran] =  self.fetch_cardinality_quran(params[:quran]).first
        cardinality[:content] =  self.fetch_cardinality_content(params[:content])

        return cardinality
    end
    def self.fetch_cardinality_quran(params_quran)
        
        self
        .joins('JOIN content.resource_api_version  using ( resource_id )')
        .select([:sub_type, :cardinality_type, :language_code, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
        .where("content.resource.is_available = 't' AND content.resource.type = 'quran'")
        .where("content.resource_api_version.v2_is_enabled = 't' ")
        .where("content.resource.resource_id = ?", params_quran)
        
    end

    def self.fetch_cardinality_content(params_content)
        params_content = params_content.split(",").map{|p| p.to_i}

        self
        .joins("JOIN content.resource_api_version  using ( resource_id )")
        .where("content.resource.is_available = 't' ")
        .where("content.resource_api_version.v2_is_enabled = 't' ")
        .where("content.resource.type = 'content' ")
        .where("content.resource.resource_id IN (?)", params_content)
        .order("content.resource.resource_id")

        
    end

    def self.bucket_result(params_quran, keys, cut_select)
        self
        .joins("JOIN quran.word_font using (resource_id)")
        .joins("JOIN quran.ayah using (ayah_key) ")
        .joins("JOIN quran.char_type ct on ct.char_type_id = quran.word_font.char_type_id")
        .joins("left join quran.word w on w.word_id = quran.word_font.word_id")
        .joins("left join quran.word_translation wt on w.word_id = wt.word_id and wt.language_code = 'en'")
        .joins("left join quran.token t on w.token_id = t.token_id")
        .joins("left join quran.word_stem ws on w.word_id = ws.word_id")
        .joins("left join quran.word_lemma wl on w.word_id = wl.word_id")
        .joins("left join quran.word_root wr on w.word_id = wr.word_id")
        .joins("left join quran.stem s on ws.stem_id = s.stem_id")
        .joins("left join quran.stem s on ws.stem_id = s.stem_id")
        .joins("left join quran.lemma l on wl.lemma_id = l.lemma_id")
        .joins("left join quran.root qr on wr.root_id = qr.root_id")
        .where("content.resource.resource_id = ? ", params_quran)
        .where("quran.ayah.ayah_key IN (?)", keys)
        .select("content.resource.resource_id")
        .select("quran.word_font.*")
        .select(cut_select)
        .select("wt.value word_translation
             , t.value word_arabic
             , l.value word_lemma
             , qr.value word_root
             , s.value word_stem")
        .order("quran.ayah.surah_id, quran.ayah.ayah_num, quran.word_font.position")
        .map do |word|
            {
                ayah_key: word.ayah_key,
                word: {
                    stem: word.word_stem,
                    arabic: word.word_arabic,
                    lemma: word.word_lemma,
                    id: word.word_id,
                    root: word.word_root,
                    translation: word.word_translation
                },
                char: {
                    page: word.page_num,
                    font: word.char_font,
                    code_hex: word.code_hex,
                    type_id: word.char_type_id,
                    type: word.char_type,
                    code_dec: word.code_dec,
                    line: word.line_num,
                    code: word.char_code

                }
            }
        end
        # .group_by{|a| a[:ayah_key]}
        
    end
end
