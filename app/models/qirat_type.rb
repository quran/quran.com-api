# frozen_string_literal: true
# == Schema Information
# Schema version: 20230313013539
#
# Table name: qirat_types
#
#  id                      :bigint           not null, primary key
#  audio_recitations_count :integer
#  description             :text
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class QiratType < ApplicationRecord
end
