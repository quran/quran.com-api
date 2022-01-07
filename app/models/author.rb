# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id                      :integer          not null, primary key
#  name                    :string
#  resource_contents_count :integer          default(0)
#  url                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Author < ApplicationRecord
  include NameTranslateable
  has_many :resource_contents
end
