# frozen_string_literal: true

# == Schema Information
#
# Table name: translated_names
#
#  id                 :integer          not null, primary key
#  resource_type      :string
#  resource_id        :integer
#  language_id        :integer
#  language_priority  :integer
#  name               :string
#  language_name      :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TranslatedName < ApplicationRecord
  include LanguageFilterable

  belongs_to :resource, polymorphic: true
end
