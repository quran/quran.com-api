# frozen_string_literal: true

# == Schema Information
#
# Table name: chapter_infos
#
#  id                  :integer          not null, primary key
#  chapter_id          :integer
#  text                :text
#  source              :string
#  short_text          :text
#  language_id         :integer
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
module Api
  class V3::ChapterInfoSerializer < V3::ApplicationSerializer
    attributes :chapter_id, :text, :source, :short_text, :language_name
  end
end