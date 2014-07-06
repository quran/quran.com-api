class Quran::CharType < ActiveRecord::Base
    extend Quran

    self.table_name = 'char_type'
    self.primary_key = 'char_type_id'

    belongs_to :parent, class_name: 'Quran::CharType'
    has_many :children, class_name: 'Quran::CharType', foreign_key: 'parent_id'
    has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: 'char_type_id'
end
