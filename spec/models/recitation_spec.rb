# == Schema Information
#
# Table name: recitations
#
#  id                  :integer          not null, primary key
#  reciter_name        :string
#  style               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  qirat_type_id       :integer
#  recitation_style_id :integer
#  reciter_id          :integer
#  resource_content_id :integer
#
# Indexes
#
#  index_recitations_on_qirat_type_id        (qirat_type_id)
#  index_recitations_on_recitation_style_id  (recitation_style_id)
#  index_recitations_on_reciter_id           (reciter_id)
#  index_recitations_on_resource_content_id  (resource_content_id)
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recitation do
  context 'with associations' do
    it { is_expected.to belong_to :reciter }
    it { is_expected.to belong_to :resource_content }
    it { is_expected.to belong_to :recitation_style }
  end

  context 'with columns and indexes' do
    columns = {
      reciter_id:          :integer,
      resource_content_id: :integer,
      recitation_style_id: :integer,
      reciter_name:        :string,
      style:               :string
    }

    indexes = [
      ['recitation_style_id'],
      ['reciter_id'],
      ['resource_content_id']
    ]

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', indexes
  end
end
