# frozen_string_literal: true
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

class Token < ApplicationRecord
end
