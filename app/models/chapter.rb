# == Schema Information
#
# Table name: chapters
#
#  id               :integer          not null, primary key
#  bismillah_pre    :boolean
#  revelation_order :integer
#  revelation_place :string
#  name_complex     :string
#  name_arabic      :string
#  pages            :string
#  verses_count     :integer
#  chapter_number   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Chapter < ApplicationRecord
  has_many :verses, inverse_of: :chapter
  has_many :translated_names, as: :resource

  serialize :pages
end
