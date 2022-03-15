# frozen_string_literal: true

module Qr
  class AuthorsPresenter < QrPresenter
    def initialize(params)
      super

      @finder = ::Qr::AuthorsFinder.new(params)
    end

    def authors
      finder.authors(filter: params[:type].presence)
    end

    def followers
      finder.followers(author_id: params[:author_id])
    end

    def followings
      finder.followings(author_id: params[:author_id])
    end

    def author_fields
      if (fields = params[:fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        fields.select do |field|
          AUTHOR_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end
end
