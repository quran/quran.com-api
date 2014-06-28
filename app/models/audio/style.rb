class Audio::Style < ActiveRecord::Base
    extend Audio

    self.table_name = 'style'
    self.primary_key = 'style_id'

    has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'style_id'
end
