class WordTopic < ApplicationRecord
  belongs_to :word
  belongs_to :topic
end
