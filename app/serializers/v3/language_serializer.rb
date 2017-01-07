# == Schema Information
#
# Table name: languages
#
#  id                  :integer          not null, primary key
#  name                :string
#  iso_code            :string
#  native_name         :string
#  direction           :string
#  es_analyzer_default :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class V3::LanguageSerializer < V3::ApplicationSerializer
  attributes :name, :iso_code, :native_name, :direction

  has_one :translated_name, if: :include_translated_names?

  def include_translated_names?
    scope[:language].present?
  end

  def translated_name
    if language = Language.find_by_iso_code(scope[:language])
      object.translated_names.find_by_language_id(language.id)
    end
  end
end
