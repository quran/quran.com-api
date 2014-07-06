class Quran::WordStem < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_stem'
    self.primary_keys = :word_id, :stem_id, :position

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :stem, class_name: 'Quran::Stem'
end
