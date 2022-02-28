# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: qirat_types
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  recitations_count :integer          default("0")
#

class QiratType < ApplicationRecord
end
