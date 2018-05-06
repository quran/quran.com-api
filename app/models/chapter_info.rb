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
#  language_name       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ChapterInfo < ApplicationRecord
  include LanguageFilterable

  belongs_to :chapter
  belongs_to :resource_content
end
