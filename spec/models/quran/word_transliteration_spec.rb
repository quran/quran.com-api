# == Schema Information
#
# Table name: quran.word_transliteration
#
#  transliteration_id :integer          not null, primary key
#  word_id            :integer
#  language_code      :string
#  value              :string
#

require 'rails_helper'

RSpec.describe Quran::WordTransliteration, type: :model do
end
