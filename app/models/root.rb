# frozen_string_literal: true

# == Schema Information
# Schema version: 20220325102524
#
# Table name: roots
#
#  id                    :integer          not null, primary key
#  arabic_trilateral     :string
#  dictionary_image_path :string
#  en_translations       :jsonb
#  english_trilateral    :string
#  text_clean            :string
#  text_uthmani          :string
#  uniq_words_count      :integer
#  ur_translations       :jsonb
#  value                 :string
#  words_count           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_roots_on_arabic_trilateral   (arabic_trilateral)
#  index_roots_on_english_trilateral  (english_trilateral)
#  index_roots_on_text_clean          (text_clean)
#  index_roots_on_text_uthmani        (text_uthmani)
#

class Root < ApplicationRecord
  has_many :word_roots
  has_many :words, through: :word_roots
  has_many :verses, through: :words
end
