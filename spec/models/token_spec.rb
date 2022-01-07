# == Schema Information
#
# Table name: tokens
#
#  id                   :integer          not null, primary key
#  record_type          :string
#  text                 :text
#  text_imlaei          :string
#  text_imlaei_simple   :string
#  text_indopak         :string
#  text_uthmani         :string
#  text_uthmani_tajweed :string
#  uniq_token_count     :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  record_id            :integer
#  resource_content_id  :integer
#
# Indexes
#
#  index_tokens_on_record_type_and_record_id  (record_type,record_id)
#  index_tokens_on_resource_content_id        (resource_content_id)
#  index_tokens_on_text                       (text)
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
