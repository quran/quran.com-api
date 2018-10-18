# frozen_string_literal: true

# == Schema Information
#
# Table name: char_types
#
#  id          :integer          not null, primary key
#  name        :string
#  parent_id   :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CharType < ApplicationRecord
  belongs_to :parent, class_name: 'CharType'
  has_many :children, class_name: 'CharType', foreign_key: 'parent_id'
end
