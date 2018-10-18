# frozen_string_literal: true

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

class Language < ApplicationRecord
  has_many :translated_names, as: :resource

  class << self
    def default
      Language.find_by_iso_code(:en)
    end

    def find_by_id_or_iso_code(id)
      Language.where(id: id).or(Language.where(iso_code: id)).first
    end
  end
end
