# frozen_string_literal: true

# == Schema Information
#
# Table name: char_types
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :integer
#
# Indexes
#
#  index_char_types_on_parent_id  (parent_id)
#

class CharType < ApplicationRecord
  belongs_to :parent, class_name: 'CharType'
  has_many :children, class_name: 'CharType', foreign_key: 'parent_id'
end
