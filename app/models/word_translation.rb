class WordTranslation < ApplicationRecord
  belongs_to :word
  belongs_to :language
  belongs_to :resource_content
end
