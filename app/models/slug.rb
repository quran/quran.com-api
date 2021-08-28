# frozen_string_literal: true

# == Schema Information
#
# Table name: slugs
#
#  id         :bigint           not null, primary key
#  is_default :boolean          default(FALSE)
#  locale     :string
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chapter_id :bigint
#
# Indexes
#
#  index_slugs_on_chapter_id           (chapter_id)
#  index_slugs_on_chapter_id_and_slug  (chapter_id,slug)
#  index_slugs_on_is_default           (is_default)
#
class Slug < ApplicationRecord
  belongs_to :chapter
end
