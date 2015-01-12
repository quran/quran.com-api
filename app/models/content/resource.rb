class Content::Resource < ActiveRecord::Base
    extend Content

    self.table_name = 'resource'
    self.primary_key = 'resource_id'

    self.inheritance_column = nil

    belongs_to :author, class_name: 'Content::Author', foreign_key: 'author_id'
    belongs_to :source, class_name: 'Content::Source', foreign_key: 'source_id'
    belongs_to :language, class_name: 'Locale::Language', foreign_key: 'language_code'

    # maybe make the block below a polymorphic class, accessible via 'content' or something
    # dunno wth polymorphic relationships really are, so maybe not -- fancy crap not worth a brain cell
    has_many :_image, class_name: 'Quran::Image', foreign_key: 'resource_id'
    has_many :_text, class_name: 'Quran::Text', foreign_key: 'resource_id'
    has_many :_word_font, class_name: 'Quran::WordFont', foreign_key: 'resource_id'
    has_many :_tafsir, class_name: 'Content::Tafsir', foreign_key: 'resource_id'
    has_many :_translation, class_name: 'Content::Translation', foreign_key: 'resource_id'
    has_many :_transliteration, class_name: 'Content::Transliteration', foreign_key: 'resource_id'
    has_one  :_resource_api_version, class_name: 'Content::ResourceAPIVersion', foreign_key: 'resource_id'


    # OPTIONS RELATED
    def self.list_quran_options
        self.joins(:_resource_api_version)
            .select([:resource_id, :sub_type, :cardinality_type, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
            .where("content.resource.type = 'quran' AND content.resource_api_version.v2_is_enabled = 't'")
    end

    def self.list_content_options
        self.joins(:_resource_api_version)
            .select([:resource_id, :sub_type, :cardinality_type, :language_code, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
            .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.type = 'content'")
    end

    def self.list_language_options
        self.joins(:language, :_resource_api_version)
            .select("i18n.language.language_code,i18n.language.unicode, i18n.language.english, i18n.language.direction")
            .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.is_available = 't'")
            .group("i18n.language.language_code, i18n.language.unicode, i18n.language.english, i18n.language.direction")
            .order("i18n.language.language_code")
    end




    # BUCKET RELATED
    def self.fetch_cardinalities(params)
        cardinality = Hash.new
        cardinality[:quran]   = self.fetch_cardinality_quran(params[:quran]).first if params.key? :quran
        cardinality[:content] = self.fetch_cardinality_content(params[:content])   if params[:content] #.key? :content
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

    def bucket_results_quran(params, keys)
        cut = Hash.new

        if self.cardinality_type == "1_ayah"

            Content::Resource
            .joins("JOIN quran.text c using ( resource_id )")
            .joins("JOIN quran.ayah using ( ayah_key )")
            .select("c.*")
            .where("content.resource.resource_id = ?", params[:quran])
            .where("quran.ayah.ayah_key IN (?)", keys)
            .order("quran.ayah.surah_id, quran.ayah.ayah_num")

        elsif self.cardinality_type == "1_word"

            if  self.slug == 'word_font' 
                cut[:select] = "
                              concat( 'p', c.page_num ) char_font
                             , concat( '&#x', c.code_hex, ';' ) char_code
                             , ct.name char_type
                        "
                cut[:join] = "join quran.char_type ct on ct.char_type_id = c.char_type_id"
            end

            results = Content::Resource
            .joins("JOIN quran.word_font c using ( resource_id )")
            .joins("JOIN quran.ayah using (ayah_key) ")
            .joins(cut[:join])
            .joins("left join quran.word w on w.word_id = c.word_id")
            .joins("left join quran.word_translation wt on w.word_id = wt.word_id and wt.language_code = 'en'")
            .joins("left join quran.token t on w.token_id = t.token_id")
            .where("content.resource.resource_id = ? ", params[:quran])
            .where("quran.ayah.ayah_key IN (?)", keys)
            .select("c.*")
            .select("content.resource.resource_id")
            .select(cut[:select])
            .select("wt.value word_translation
                 , t.value word_arabic" )
            .order("quran.ayah.surah_id, quran.ayah.ayah_num, c.position")
            .to_a # Must make it into an array to use the .uniq function otherwise will trigger ActiveResource
            .map do |word|
                {
                    ayah_key: word.ayah_key,
                    word: {
                        position: word.position,
                        arabic: word.word_arabic,
                        id: word.word_id,
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
            .group_by{|a| a[:ayah_key]}.values
            
            return results
        end
    end

    def self.bucket_results_content(row, keys)
        if row.cardinality_type == 'n_ayah'
            join = "JOIN i18n.language l using ( language_code ) JOIN #{row.type}.#{row.sub_type} c using ( resource_id ) JOIN #{row.type}.#{row.sub_type}_ayah n using ( #{row.sub_type}_id )"
        elsif row.cardinality_type == '1_ayah'
            join = "JOIN i18n.language l using ( language_code ) JOIN #{row.type}.#{row.sub_type} c using ( resource_id )"
        end
        if row.cardinality_type == 'n_ayah'
            self
            .joins(join)
            .joins("JOIN quran.ayah using ( ayah_key )")
            .select("c.resource_id, l.language_code lang, l.direction dir, quran.ayah.ayah_key, concat( '/', concat_ws( '/', '#{row.type}', '#{row.sub_type}', c.#{row.sub_type}_id ) ) url, content.resource.slug, content.resource.name")
            .where("content.resource.resource_id = ?", row.resource_id)
            .where("quran.ayah.ayah_key IN (?)", keys)
            .order("quran.ayah.surah_id , quran.ayah.ayah_num")

        elsif row.cardinality_type == '1_ayah'
            self
            .joins(join)
            .joins("join quran.ayah using ( ayah_key )")
            .select("c.*, l.language_code lang, l.direction dir, content.resource.slug, content.resource.name")
            .where("content.resource.resource_id = ?", row.resource_id)
            .where("quran.ayah.ayah_key IN (?)", keys)
            .order("quran.ayah.surah_id , quran.ayah.ayah_num")

        end
    end
end
