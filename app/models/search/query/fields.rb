module Search
  module Query
    module Fields
      def fields
        # This does nothing to the initial query!
        ["ayah.ayah_key", "ayah.ayah_num", "ayah.surah_id", "ayah.ayah_index", "text"]
      end

      def fields_val
        if @query.is_arabic?
          [
            'text^5',
            'text.lemma^4',
            'text.stem^3',
            'text.root^1.5',
            'text.lemma_clean^3',
            'text.stem_clean^2',
            'text.ngram^2',
            'text.stemmed^2'
          ]
        else
          [
            'text^2.5',
            'text.shingles^1.5',
            'text.phonetic^1.1',
            'text.stemmed'
          ]
        end
      end
    end
  end
end
