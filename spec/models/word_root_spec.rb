# == Schema Information
#
# Table name: word_roots
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  root_id    :integer
#  word_id    :integer
#
# Indexes
#
#  index_word_roots_on_root_id  (root_id)
#  index_word_roots_on_word_id  (word_id)
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WordRoot do
  context 'with associations' do
    it { is_expected.to belong_to :word }
    it { is_expected.to belong_to :root }
  end

  context 'with columns and indexes' do
    columns = { word_id: :integer, root_id: :integer }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', [['root_id'], ['word_id']]
  end
end
