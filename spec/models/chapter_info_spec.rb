# == Schema Information
#
# Table name: chapter_infos
#
#  id                  :integer          not null, primary key
#  language_name       :string
#  short_text          :text
#  source              :string
#  text                :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  chapter_id          :integer
#  language_id         :integer
#  resource_content_id :integer
#
# Indexes
#
#  index_chapter_infos_on_chapter_id           (chapter_id)
#  index_chapter_infos_on_language_id          (language_id)
#  index_chapter_infos_on_resource_content_id  (resource_content_id)
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChapterInfo do
  describe 'modules' do
    it { is_expected.to include_module(ActionView::Helpers::NumberHelper) }
  end

  context 'with associations' do
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :chapter }
    it { is_expected.to belong_to :resource_content }
  end

  context 'with columns and indexes' do
    columns = {
      chapter_id:          :integer,
      text:                :text,
      source:              :string,
      short_text:          :text,
      language_id:         :integer,
      resource_content_id: :integer,
      language_name:       :string
    }

    indexes = [
      ['chapter_id'],
      ['language_id'],
      ['resource_content_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
