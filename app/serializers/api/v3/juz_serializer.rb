# frozen_string_literal: true

module Api
  class V3::JuzSerializer < V3::ApplicationSerializer
    attributes :id, :juz_number, :verse_mapping
  end
end
