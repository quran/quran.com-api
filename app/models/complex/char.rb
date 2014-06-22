class Complex::Char < ActiveRecord::Base
    extend Complex

    self.table_name = 'char'
    self.primary_key = 'char_id'
end
