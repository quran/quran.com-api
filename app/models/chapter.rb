# == Schema Information
#
# Table name: chapters
#
#  id               :integer          not null, primary key
#  bismillah_pre    :boolean
#  revelation_order :integer
#  revelation_place :string
#  name_complex     :string
#  name_simple      :string
#  page_number      :integer
#  verses_count     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Chapter < ApplicationRecord
  has_many :verses, inverse_of: :chapter
  has_many :translated_names, as: :resource

  serialize :pages

  class << self
    def import_from_v2

    end
  end
end
