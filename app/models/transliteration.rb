# frozen_string_literal: true

# == Schema Information
#
# Table name: transliterations
#
#  id                  :integer          not null, primary key
#  language_name       :string
#  resource_type       :string
#  text                :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  language_id         :integer
#  resource_content_id :integer
#  resource_id         :integer
#
# Indexes
#
#  index_transliterations_on_language_id                    (language_id)
#  index_transliterations_on_resource_content_id            (resource_content_id)
#  index_transliterations_on_resource_type_and_resource_id  (resource_type,resource_id)
#

class Transliteration < ApplicationRecord
  include LanguageFilterable
  include Resourceable

  belongs_to :resource, polymorphic: true

  def resource_name
  end
end
