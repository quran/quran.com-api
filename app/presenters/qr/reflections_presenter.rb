# frozen_string_literal: true

module Qr
  class ReflectionsPresenter < QrPresenter
    REFLECTION_FIELDS = [
      'post_type',
      'author_id',
      'likes_count',
      'comments_count',
      'views_count',
      'language_id',
      'language_name',
      'body',
      'html_body',
      'created_at',
      'updated_at',
      'verified'
    ].freeze

    def initialize(params)
      super(params)

      @finder = ::Qr::ReflectionsFinder.new(params)
    end

    def reflections
      finder.filter(
        verified: lookahead.selects?(:verified),
        filter: filter_name,
        authors: filter_authors,
        tags: filter_tags,
        ranges: filter_ranges,
        include_author: render_author?,
        include_comments: render_comments?,
        op: filter_op
      )
    end

    def find
      finder.find(params[:id], include_author: render_author?, include_comments: render_comments?)
    end

    def reflection_fields
      if (fields = params[:fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        fields.select do |field|
          REFLECTION_FIELDS.include?(field)
        end
      else
        []
      end
    end

    protected

    def filter_op
      params[:op] || 'and'
    end

    def filter_authors
      if lookahead.selects?(:authors)
        Qr::Author.with_username_or_id(params[:authors]).pluck(:id)
      end
    end

    def filter_name
      params[:filter].presence
    end

    def filter_tags
      if lookahead.selects?(:authors)
        Qr::Tag.with_tagname_or_id(params[:authors]).pluck(:id)
      end
    end

    def filter_ranges
      params[:ranges].presence
    end
  end
end
