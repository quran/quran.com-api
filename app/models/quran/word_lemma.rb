class Quran::WordLemma < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_lemma'
    self.primary_keys = :word_id, :lemma_id, :position

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :lemma, class_name: 'Quran::Lemma'
end


