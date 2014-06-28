class Audio::Recitation < ActiveRecord::Base
    extend Audio

    self.table_name = 'recitation'
    self.primary_key = 'recitation_id'

    belongs_to :reciter, class_name: 'Audio::Reciter'
    belongs_to :style,   class_name: 'Audio::Style'

    has_many :audio, class_name: 'Audio::File', foreign_key: 'recitation_id'

end
