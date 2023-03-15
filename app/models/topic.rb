# frozen_string_literal: true

# == Schema Information
# Schema version: 20230313013539
#
# Table name: topics
#
#  id                  :integer          not null, primary key
#  arabic_name         :string
#  ayah_range          :string
#  childen_count       :integer          default(0)
#  depth               :integer          default(0)
#  description         :text
#  name                :string
#  ontology            :boolean
#  relatd_topics_count :integer          default(0)
#  thematic            :boolean
#  wikipedia_link      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ontology_parent_id  :integer
#  parent_id           :integer
#  resource_content_id :integer
#  thematic_parent_id  :integer
#
# Indexes
#
#  index_topics_on_depth               (depth)
#  index_topics_on_name                (name)
#  index_topics_on_ontology            (ontology)
#  index_topics_on_ontology_parent_id  (ontology_parent_id)
#  index_topics_on_parent_id           (parent_id)
#  index_topics_on_thematic            (thematic)
#  index_topics_on_thematic_parent_id  (thematic_parent_id)
#

class Topic < ApplicationRecord
  belongs_to :parent, class_name: 'Topic'
  belongs_to :children, class_name: 'Topic', foreign_key: 'parent_id'

  #has_many :words
  #has_many :verses, through: :words
  has_many :related_topics
end
