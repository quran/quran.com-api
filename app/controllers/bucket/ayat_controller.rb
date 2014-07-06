class Bucket::AyatController < ApplicationController
    def index
        # @results = Quran::Ayah.where( surah_id: 1 ).order( :ayah_num )

        range = params[:range]
        range = range.split("-")

        if (range.last.to_i - range.first.to_i) > 50
            raise APIValidation, "Range not set or invalid, use a string or an array (maximum 50 ayat per request), e.g. '1-3' or [ 1, 3 ]"
            
        end
        
        @keys = Quran::Ayah
        .where("quran.ayah.surah_id = ? AND quran.ayah.ayah_num >= ? AND quran.ayah.ayah_num <= ?", params[:surah], range.first, range.last)
        .order("quran.ayah.surah_id, quran.ayah.ayah_num")

        

        @cardinalities = Content::Resource.get_cardinality(params[:quran])

        # cut = Hash.new

        # if @resulting.first.cardinality_type == "1_ayah"
        #     @check = "1_ayah"
        #     join = "join quran.text c using ( resource_id )";
        # else
        #     @check = "1_word"
        #     join = "join quran.word_font c using ( resource_id )";
            
        #     if  @resulting.first.slug == 'word_font' 
        #         cut[:select] = "
        #                      , concat( 'p', c.page_num ) char_font
        #                      , concat( '&#x', c.code_hex, ';' ) char_code
        #                      , ct.name char_type
        #                 "
        #         cut[:join] = "join quran.char_type ct on ct.char_type_id = c.char_type_id"
        #     end

        #     @results = Content::Resource.joins(:_word_font).joins("quran.ayah using ( ayah_key )").joins("join quran.char_type ct on ct.char_type_id = c.char_type_id")
        #     @results = Content::Resource
        #     .joins(:_word_font)#.joins(join)
        #     .join("quran.ayah using ( ayah_key )")
        #     .join("join quran.char_type ct on ct.char_type_id = c.char_type_id")#.join(cut[:join])
                        
        # end




         
    end
end
