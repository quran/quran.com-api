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

        opts = Hash.new
        opts[:id] = "r.resource_id";
        opts[:type] = "r.sub_type";
        opts[:cardinality] = "r.cardinality_type";
        opts[:language] = "r.language_code";

        opts.keys.sort.each do |key|

        end

        sql = 'select r.resource_id id
        , r.sub_type "type"
        , r.cardinality_type cardinality
        , r.slug
        , r.is_available
        , r.description
        , r.name
        from content.resource r
        join content.resource_api_version v using ( resource_id )
        where r.type =' + " 'quran'
        and v.v2_is_enabled"

        results = ActiveRecord::Base.connection.execute(sql)
        @results = results.to_a

        
    end

    def content

        # sql = 'select r.resource_id id
        #          , r.sub_type "type"
        #          , r.cardinality_type cardinality
        #          , r.language_code "language"
        #          , r.slug
        #          , r.is_available
        #          , r.description
        #          , r.name
        #       from content.resource r
        #       join content.resource_api_version v using ( resource_id )
        #      where r.type =' +  "'content'
        #        and v.v2_is_enabled"

        # results = ActiveRecord::Base.connection.execute(sql)
        # @results = results.to_a

        @results = Content::Resource
        .joins(:_resource_api_version)
        .select([:resource_id, :sub_type, :cardinality_type, :language_code, :slug, :is_available, :description, :name].map{ |term| "content.resource.#{term}" }.join(', '))
        .where("content.resource_api_version.v2_is_enabled = 't' AND content.resource.type = 'content'")
        

        
    end

    def audio

        sql = "select t.recitation_id id
                 , t.reciter_id
                 , t.style_id
                 , r.slug reciter_slug
                 , s.slug style_slug
                 , concat_ws( ' ', r.english, case when ( s.english is not null ) then concat( '(', s.english, ')' ) end ) name_english
                 , concat_ws( ' ', r.arabic, case when ( s.arabic is not null ) then concat( '(', s.arabic, ')' ) end ) name_arabic
              from audio.recitation t
              join audio.reciter r using ( reciter_id )
              left join audio.style s using ( style_id )
             where t.is_enabled
             order by r.english, s.english, t.recitation_id"

        results = ActiveRecord::Base.connection.execute(sql)
        @results = results.to_a

        
    end
end
