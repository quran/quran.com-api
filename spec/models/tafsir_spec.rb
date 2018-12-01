# == Schema Information
#
# Table name: tafsirs
#
#  id                  :integer          not null, primary key
#  verse_id            :integer
#  language_id         :integer
#  text                :text
#  language_name       :string
#  resource_content_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  resource_name       :string
#  verse_key           :string
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tafsir do

  context 'with associations' do
    it { is_expected.to belong_to :verse }
    it { is_expected.to belong_to :language }
    it { is_expected.to belong_to :resource_content }

    it { is_expected.to have_many :foot_notes }
  end

  context 'with columns and indexes' do
    columns = {
      verse_id:            :integer,
      language_id:         :integer,
      text:                :text,
      language_name:       :string,
      resource_content_id: :integer,
      resource_name:       :string,
      verse_key:           :string
    }

    indexes = [
      ['language_id'],
      ['resource_content_id'],
      ['verse_id'],
      ['verse_key']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
