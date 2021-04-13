# frozen_string_literal: true

# == Schema Information
#
# Table name: tokens
#
#  id                   :integer          not null, primary key
#  text_imlaei          :string
#  text_imlaei_simple   :string
#  text_indopak         :string
#  text_uthmani         :string
#  text_uthmani_tajweed :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Token < ApplicationRecord
end
