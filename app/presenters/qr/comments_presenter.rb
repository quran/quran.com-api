# frozen_string_literal: true

module Qr
  class CommentsPresenter < QrPresenter
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
      super(params, '')

      @finder = ::Qr::CommentsFinder.new(params)
    end

    def comments
      finder.comments(
        post_id: params[:post_id],
        include_author: render_author?,
        include_replies: render_replies?
      )
    end

    def replies
      finder.replies(
        params[:comment_id],
        include_author: render_author?
      )
    end

    def find
      finder.find(params[:id], include_author: render_author?, include_replies: render_replies?)
    end

    def comment_fields
      if (fields = params[:fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        fields.select do |field|
          COMMENTS_FIELDS.include?(field)
        end
      else
        []
      end
    end
  end
end
