class Quran::Word < ActiveRecord::Base
    extend Quran

    self.table_name = 'word'
    self.primary_key = 'word_id'

    belongs_to :ayah, class_name: 'Quran::Ayah'
    belongs_to :token, class_name: 'Quran::Token'

    has_many :translations, class_name: 'Quran::WordTranslation', foreign_key: 'word_id'
    has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: 'word_id'

    has_many :_word_lemma, class_name: 'Quran::WordLemma', foreign_key: 'word_id'
    has_many :_word_root, class_name: 'Quran::WordRoot', foreign_key: 'word_id'
    has_many :_word_stem, class_name: 'Quran::WordStem', foreign_key: 'word_id'

    has_many :stems,  class_name: 'Quran::Stem',  through: :_word_stem
    has_many :lemmas, class_name: 'Quran::Lemma', through: :_word_lemma
    has_many :roots,  class_name: 'Quran::Root',  through: :_word_root

end
