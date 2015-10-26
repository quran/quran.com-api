# == Schema Information
#
# Table name: quran.word_stem
#
#  word_id  :integer          not null, primary key
#  stem_id  :integer          not null, primary key
#  position :integer          default(1), not null, primary key
#

class Quran::WordStem < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_stem'
    self.primary_keys = :word_id, :stem_id, :position

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :stem, class_name: 'Quran::Stem'
end
