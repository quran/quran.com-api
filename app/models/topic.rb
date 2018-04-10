# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ApplicationRecord
  belongs_to :parent, class_name: 'Topic'
  belongs_to :children, class_name: 'Topic', foreign_key: 'parent_id'
  has_many :words
  has_many :verses, through: :words
end
