class I18N::Language < ActiveRecord::Base
    extend I18N

    self.table_name = 'language'
    self.primary_key = 'language_code'
end
