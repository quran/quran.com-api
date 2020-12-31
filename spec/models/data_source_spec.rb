# == Schema Information
#
# Table name: data_sources
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataSource do
  context 'with associations' do
   it { should have_many(:resource_contents) }
 end

  context 'columns and indexes' do
    columns = {
      name: :string,
      url: :string
    }

    it_behaves_like 'modal with column', columns
  end
end
