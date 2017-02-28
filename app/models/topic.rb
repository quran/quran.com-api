class Topic < ApplicationRecord
  belongs_to :parent, class_name: 'Topic'
  belongs_to :children, class_name: 'Topic', foreign_key: 'parent_id'
  has_many :word_topics
  has_many :words, through: :word_topics
end
