# frozen_string_literal: true

# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  direction           :string
#  es_analyzer_default :string
#  es_indexes          :string
#  iso_code            :string
#  name                :string
#  native_name         :string
#  translations_count  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_languages_on_iso_code            (iso_code)
#  index_languages_on_translations_count  (translations_count)
#

class Language < ApplicationRecord
  include NameTranslateable

  scope :with_translations, -> { where('translations_count > 0').order('translations_count DESC') }

  class << self
    def default
      Language.find_by(iso_code: :en)
    end

    def find_with_id_or_iso_code(id)
      Language.where(id: id).or(Language.where(iso_code: id)).first
    end
  end
end
