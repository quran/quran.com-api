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

class V3::ChapterSerializer < V3::ApplicationSerializer
  attributes :chapter_number, :bismillah_pre, :revelation_order, :revelation_place, :name_complex, :name_arabic, :name_simple, :verses_count, :pages

  has_many :translated_names do
    object.translated_names.filter_by_language_or_default(scope[:language])
  end
end
