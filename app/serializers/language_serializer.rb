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

class LanguageSerializer < ActiveModel::Serializer
  attributes :id, :name, :iso_code, :native_name, :direction, :es_analyzer_default
end
