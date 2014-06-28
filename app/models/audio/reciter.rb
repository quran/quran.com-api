class Audio::Reciter < ActiveRecord::Base
    extend Audio

    self.table_name = 'reciter'
    self.primary_key = 'reciter_id'

    has_many :recitations, class_name: 'Audio::Recitation', foreign_key: 'reciter_id'
end
