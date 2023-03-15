# frozen_string_literal: true

# == Schema Information
# Schema version: 20230313013539
#
# Table name: tokens
#
#  id                  :integer          not null, primary key
#  record_type         :string
#  text                :text
#  text_clean          :string
#  text_indopak        :string
#  text_madani         :string
#  uniq_token_count    :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  record_id           :integer
#  resource_content_id :integer
#
# Indexes
#
#  index_tokens_on_record_type_and_record_id  (record_type,record_id)
#  index_tokens_on_resource_content_id        (resource_content_id)
#  index_tokens_on_text                       (text)
#

class Token < ApplicationRecord
end
