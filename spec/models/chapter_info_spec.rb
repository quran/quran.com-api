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

require "rails_helper"

RSpec.describe ChapterInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
