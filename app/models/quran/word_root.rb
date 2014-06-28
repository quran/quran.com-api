class Quran::WordRoot < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_root'
    self.primary_keys = :word_id, :root_id, :position

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :root, class_name: 'Quran::Root'
end

