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

class ChapterSerializer < ActiveModel::Serializer
  attributes :id, :bismillah_pre, :revelation_order, :revelation_place, :name_complex, :name_simple, :verses_count
end
