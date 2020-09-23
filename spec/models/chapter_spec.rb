# == Schema Information
#
# Table name: chapters
#
#  id               :integer          not null, primary key
#  bismillah_pre    :boolean
#  revelation_order :integer
#  revelation_place :string
#  name_complex     :string
#  name_arabic      :string
#  name_simple      :string
#  pages            :string
#  verses_count     :integer
#  chapter_number   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chapter do
  context 'with associations and scopes' do
    it { is_expected.to have_many :verses }
    it { is_expected.to have_many :translated_names }
    it { is_expected.to have_many :chapter_infos }

    it { is_expected.to serialize :pages }

    it 'orders by chapter_number' do
      expect(described_class.default_scoped.to_sql)
        .to include('ORDER BY chapter_number asc')
    end
  end

  context 'with columns and indexes' do
    columns = {
      bismillah_pre:    :boolean,
      revelation_order: :integer,
      revelation_place: :string,
      name_complex:     :string,
      name_arabic:      :string,
      name_simple:      :string,
      pages:            :string,
      verses_count:     :integer,
      chapter_number:   :integer,
    }

    it_behaves_like 'modal with column', columns
    it_behaves_like 'modal have indexes on column', ['chapter_number']
  end
end
