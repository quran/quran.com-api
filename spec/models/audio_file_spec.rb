# == Schema Information
#
# Table name: audio_files
#
#  id            :integer          not null, primary key
#  resource_type :string
#  resource_id   :integer
#  url           :text
#  duration      :integer
#  segments      :text
#  mime_type     :string
#  format        :string
#  is_enabled    :boolean
#  recitation_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioFile do
  context 'with associations' do
    it { is_expected.to belong_to(:verse) }
    it { is_expected.to belong_to(:recitation) }
    it { is_expected.to serialize(:segments).as(Array) }
  end

  context 'with columns and indexes' do
    columns = {
      verse_id:   :integer,
      url:           :text,
      duration:      :integer,
      segments:      :text,
      mime_type:     :string,
      format:        :string,
      is_enabled:    :boolean,
      recitation_id: :integer
    }

    indexes = [
      ['is_enabled'],
      ['recitation_id'],
      ['verse_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
