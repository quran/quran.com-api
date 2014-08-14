class SearchController < ApplicationController

    def query
    	string = params[:query]

    	# config = Hash.new
    	# config[:type] ||= [ "qw/quran.text/", "qw/quran.token", "quran.stem", 
    	# 					"quran.lemma", "quran.root", "content.tafsir" ] if  string =~ /^(?:\s*[\p{Arabic}\p{Diacritic}]+\s*)+$/

    	# config[:type] ||= [ "qw/content.transliteration", "content.translation", "content.tafsir" ] if string =~ /^(?:\s*\p{ASCII}+\s*)+$/;

    	# config[:type] ||= [ "qw/content.translation", "content.tafsir" ]

    	@results = Content::Translation.searching(params)
    	

    	
    end
end
