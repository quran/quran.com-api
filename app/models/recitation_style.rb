# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: recitation_styles
#
#  id                :integer          not null, primary key
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  arabic            :string
#  slug              :string
#  description       :text
#  recitations_count :integer          default("0")
#
# Indexes
#
#  index_recitation_styles_on_slug  (slug)
#

class RecitationStyle < ApplicationRecord
  include NameTranslateable
end
