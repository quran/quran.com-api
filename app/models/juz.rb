# frozen_string_literal: true
# == Schema Information
#
# Table name: juzs
#
#  id            :integer          not null, primary key
#  juz_number    :integer
#  name_simple   :string
#  name_arabic   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  verse_mapping :json
#

class Juz < ApplicationRecord
  serialize :verse_mapping, Hash

  include QuranNavigationSearchable

  has_many :verses, foreign_key: :juz_number
  has_many :chapters, through: :verses
end
