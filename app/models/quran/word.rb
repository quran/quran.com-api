class Quran::Word < ActiveRecord::Base
    extend Quran

    self.table_name = 'word'
    self.primary_key = 'word_id'

    belongs_to :ayah, class_name: 'Quran::Ayah'
    belongs_to :root, class_name: 'Quran::Root'
    belongs_to :stem, class_name: 'Quran::Stem'
    belongs_to :term, class_name: 'Quran::Term'
end
