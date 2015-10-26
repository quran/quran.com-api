# == Schema Information
#
# Table name: quran.word_lemma
#
#  word_id  :integer          not null, primary key
#  lemma_id :integer          not null, primary key
#  position :integer          default(1), not null, primary key
#

class Quran::WordLemma < ActiveRecord::Base
    extend Quran

    self.table_name = 'word_lemma'
    self.primary_keys = :word_id, :lemma_id, :position

    belongs_to :word, class_name: 'Quran::Word'
    belongs_to :lemma, class_name: 'Quran::Lemma'
end


