# == Schema Information
#
# Table name: transliterations
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  language_id         :integer
#  text                :text
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::SimpleVerseSerializer < V3::ApplicationSerializer
  attributes :id,
             :verse_number,
             :chapter_id,
             :verse_key,
             :juz_number,
             :hizb_number,
             :rub_number,
             :page_number
end
