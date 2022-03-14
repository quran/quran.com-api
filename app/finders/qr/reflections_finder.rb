module Qr
  class ReflectionsFinder < BaseFinder
    VALID_FILTERS = ['latest', 'popular', 'random', 'lessons']

    #TODO: add language filter
    def filter(filter:, verified:, authors:, tags:, ranges:, include_author: false, include_comments: false, op: 'and')
      filter = VALID_FILTERS.include?(filter) ? filter : 'latest'

      posts = send("load_#{filter}")

      if verified
        posts = add_filter(posts, load_verified)
      end

      if authors.present?
        posts = add_filter(posts, posts.where(author_id: authors), op)
      end

      if tags.present?
        with_tags = posts.join(:post_tags).where(post_tags: { tag_id: tags })
        posts = add_filter(posts, with_tags, op)
      end

      if ranges.present?
        with_ranges = posts.join(:post_filters).where(post_filters: { filter_id: ranges })
        posts = add_filter(posts, with_ranges, op)
      end

      if include_author
        posts = posts.includes(:author)
      end

      if include_comments
        posts = posts.includes(:recent_comments)
      end

      if sort_by.present?
        paginate posts.order(sort_by)
      else
        paginate posts
      end
    end

    def find(id, include_author: true, include_comments: true)
      posts = posts_table

      if include_author
        posts = posts.includes(:author)
      end

      if include_comments
        posts = posts.includes(recent_comments: :recent_replies)
      end

      posts.find id
    end

    protected

    def load_verified
      posts_table.joins(:author).where(qr_authors: { verified: true })
    end

    # Latest posts first
    def load_latest
      add_order 'qr_posts.updated_at DESC'
      posts_table
    end

    # Most popular posts first
    def load_popular
      add_order 'qr_posts.comments_count DESC, qr_posts.likes_count DESC'
      posts_table
    end

    # Posts in random
    def load_random
      add_order 'RANDOM()'
      posts_table
    end

    # Posts from scholars
    def load_lessons
      posts_table.joins(:author).where(qr_authors: { user_type: 1 })
    end

    def add_filter(table, filter, op = :and)
      if table.to_s == 'Qr::Post'
        filter
      else
        table.send(op, filter)
      end
    end

    def posts_table
      Qr::Post
    end

    def add_order(order)
      if @arel_order.nil?
        @arel_order = []
      end

      @arel_order.push(order)
    end

    def sort_by
      @arel_order
    end
  end
end