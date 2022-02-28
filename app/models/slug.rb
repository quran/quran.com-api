# frozen_string_literal: true
# == Schema Information
# Schema version: 20220109075422
#
# Table name: slugs
#
#  id                :integer          not null, primary key
#  chapter_id        :integer
#  slug              :string
#  locale            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  is_default        :boolean          default("false")
#  name              :string
#  language_priority :integer
#  language_id       :integer
#
# Indexes
#
#  index_slugs_on_chapter_id           (chapter_id)
#  index_slugs_on_chapter_id_and_slug  (chapter_id,slug)
#  index_slugs_on_is_default           (is_default)
#  index_slugs_on_language_id          (language_id)
#  index_slugs_on_language_priority    (language_priority)
#

class Slug < ApplicationRecord
  belongs_to :chapter
end
