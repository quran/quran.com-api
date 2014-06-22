class Corpus::Root < ActiveRecord::Base
    extend Corpus

    self.table_name = 'root'
    self.primary_key = 'root_id'
end
