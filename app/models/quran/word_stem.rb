# == Schema Information
#
# Table name: word_stem
#
#  word_id  :integer          not null
#  stem_id  :integer          not null
#  position :integer          default(1), not null
#

class Quran::WordStem < ActiveRecord::Base
    self.table_name = 'word_stem'

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :stem, class_name: 'Quran::Stem'
end
