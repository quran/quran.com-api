# frozen_string_literal: true
# == Schema Information
# Schema version: 20230313013539
#
# Table name: slugs
#
#  id                :bigint           not null, primary key
#  language_priority :integer
#  locale            :string
#  name              :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chapter_id        :bigint
#  language_id       :integer
#
# Indexes
#
#  index_slugs_on_chapter_id           (chapter_id)
#  index_slugs_on_chapter_id_and_slug  (chapter_id,slug)
#  index_slugs_on_language_id          (language_id)
#  index_slugs_on_language_priority    (language_priority)
#

class Slug < ApplicationRecord
  belongs_to :chapter
end
