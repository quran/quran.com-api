# frozen_string_literal: true

module Api::Qdc
  class QuranController < Api::V4::QuranController
    def tafsir
      @presenter = Qdc::TafsirsPresenter.new(params)
      filters = resource_filters(@resource)
      @filter_names = humanize_filter_names(filters)

      @tafsirs = if (@resource = fetch_tafsir_resource)
                   Tafsir.order('verse_id ASC').where(filters)
                 else
                   []
                 end

      render
    end
  end
end
