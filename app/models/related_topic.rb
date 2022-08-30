# == Schema Information
# Schema version: 20220829193210
#
# Table name: related_topics
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  related_topic_id :integer
#  topic_id         :integer
#
# Indexes
#
#  index_related_topics_on_topic_id  (topic_id)
#
class RelatedTopic < ApplicationRecord
  belongs_to :topic
  belongs_to :related_topic, class_name: 'Topic'
end
