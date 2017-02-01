module Search
  module Query
    module Fields
      def fields
        # This does nothing to the initial query!
        ["verse_key", "text_madani", "ayah.surah_id", "ayah.ayah_index", "text"]
      end

      def fields_val
        if @query.is_arabic?
          [
            'text_madani.text^5',
            'text_madani.stemmed^2',
            'chapter_names^1',
            'verse_key^2',
          ]
        else
          [
            'text_madani^2.5',
            'verse_key^2',
            'trans_*.^2',
          ]
        end
      end
    end
  end
end
