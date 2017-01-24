# == Schema Information
#
# Table name: foot_notes
#
#  id                  :integer          not null, primary key
#  resource_type       :string
#  resource_id         :integer
#  text                :text
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::FootNoteSerializer <  V3::ApplicationSerializer
  attributes :id, :text, :language_name
end
