# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: authors
#
#  id                      :integer          not null, primary key
#  name                    :string
#  url                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  resource_contents_count :integer          default("0")
#

class Author < ApplicationRecord
  include NameTranslateable
  has_many :resource_contents
end
