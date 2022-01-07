# frozen_string_literal: true

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

class RecitationStyle < ApplicationRecord
  include NameTranslateable
end
