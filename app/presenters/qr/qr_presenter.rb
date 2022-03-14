# frozen_string_literal: true

module Qr
  class QrPresenter < BasePresenter
    AUTHOR_FIELDS = [
      'verified',
      'avatar_url',
      'bio',
      'user_type',
      'followers_count',
      'followings_count',
      'created_at',
      'updated_at',
      'posts_count',
      'comments_count'
    ].freeze

    COMMENTS_FIELDS = [
      'body',
      'html_body',
      'created_at',
      'updated_at',
      'replies_count'
    ].freeze

    def author_fields
      if (fields = params[:author_fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        fields.select do |field|
          AUTHOR_FIELDS.include?(field)
        end
      else
        []
      end
    end

    def comment_fields
      if (fields = params[:comment_fields]).presence
        fields = sanitize_query_fields(fields.split(','))

        fields.select do |field|
          COMMENTS_FIELDS.include?(field)
        end
      else
        []
      end
    end

    def render_comments?
      lookahead.selects?(:comments)
    end

    def render_replies?
      lookahead.selects?(:replies)
    end

    def render_author?
      lookahead.selects?(:author)
    end
  end
end
