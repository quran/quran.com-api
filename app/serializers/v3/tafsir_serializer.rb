# frozen_string_literal: true

# == Schema Information
#
# Table name: tafsirs
#
#  id                  :integer          not null, primary key
#  verse_id            :integer
#  language_id         :integer
#  text                :text
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::TafsirSerializer < V3::ApplicationSerializer
  attributes :id, :text, :verse_id, :language_name, :resource_name, :verse_key
end
