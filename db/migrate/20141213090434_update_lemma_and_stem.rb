class UpdateLemmaAndStem < ActiveRecord::Migration
    def up
        execute <<-SQL
            update quran.lemma set value = replace( value,   substr( trim( ' ٱللَّه ' ) , 1, 1)   ,     substr(  trim( ' اللَّهُ '  ) , 1, 1 )   ) where value ~ concat( '^', substr( trim( ' ٱللَّه ' ) , 1, 1) )
        SQL
        execute <<-SQL
            update quran.stem set value = replace( value,   substr( trim( ' ٱللَّه ' ) , 1, 1)   ,     substr(  trim( ' اللَّهُ '  ) , 1, 1 )   ) where value ~ concat( '^', substr( trim( ' ٱللَّه ' ) , 1, 1) )
        SQL
    end
end
