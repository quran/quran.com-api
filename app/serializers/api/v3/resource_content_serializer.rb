# frozen_string_literal: true

# == Schema Information
#
# Table name: resource_contents
#
#  id               :integer          not null, primary key
#  approved         :boolean
#  author_id        :integer
#  data_source_id   :integer
#  author_name      :string
#  resource_type    :string
#  sub_type         :string
#  name             :string
#  description      :text
#  cardinality_type :string
#  language_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
module Api
  class V3::ResourceContentSerializer < V3::ApplicationSerializer
    attributes :id,
               :author_name,
               :slug,
               :name,
               :language_name

    has_one :translated_name
  end
end
