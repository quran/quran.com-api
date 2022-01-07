# == Schema Information
#
# Table name: recitation_styles
#
#  id                :integer          not null, primary key
#  arabic            :string
#  description       :text
#  name              :string
#  recitations_count :integer          default(0)
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_recitation_styles_on_slug  (slug)
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecitationStyle do
  context 'with associations' do
   it { is_expected.to have_many :translated_names }
 end

  context 'with columns and indexes' do
    it_behaves_like 'modal with column', style: :string
  end
end
