# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  text_madani  :string
#  text_clean   :string
#  text_indopak :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token do
  context 'with columns and indexes' do
    columns = {
      text_uthmani: :string,
      text_imlaei_simple: :string,
      text_indopak: :string,
      text_imlaei: :string,
      text_uthmani_tajweed: :string
    }

    it_behaves_like 'modal with column', columns
  end
end
