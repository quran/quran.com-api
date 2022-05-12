module Qr
  class ReflectionsFinder < BaseFinder
    VALID_FILTERS = ['latest', 'popular', 'random', 'lessons']

    #TODO: add language filter
    def filter(verified:, authors:, tags:, ranges:, filter: nil, include_author: false, include_comments: false, op: 'and')
      filter = VALID_FILTERS.include?(filter) ? filter : 'latest'

      posts = send("load_#{filter}")

      if verified
        posts = load_verified(posts)
      end

      if authors.present?
        posts = add_filter(posts, posts.where(author_id: authors), op)
      end

      if tags.present?
        posts = posts.joins(:post_tags).where(post_tags: { tag_id: tags })
      end

      if ranges.present?
        # TODO: add filter OP
        filter_ids = find_post_filters(ranges, 'or')

        posts = posts.joins(:post_filters).where(post_filters: { filter_id: filter_ids })
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

    def load_verified(posts)
      posts.joins(:author).where("qr_authors.user_type IN(:user_type) OR qr_authors.verified = :verified OR qr_posts.verified = :verified", verified: true, user_type: [1, 2])
    end

    # Latest posts first
    def load_latest
      add_order 'qr_posts.updated_at DESC'
      posts_table
    end

    # Most popular posts first
    def load_popular
      add_order 'qr_posts.ranking_weight DESC'
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
      Qr::Post.includes(:room)
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

    def find_post_filters(ranges, op)
      filter_ids = []

      ranges.split(',').compact_blank.each do |range|
        verse_range = QuranUtils::VerseRange.new(range)
        verse_ids = verse_range.get_ids

        if verse_ids.present? && (filters = Qr::Filter.find_with_verses(verse_ids).pluck(:id))
          filter_ids += filters
        end

        # Disable full surah reflection
        #if op == 'or'
        #  filter_ids += filter_ids_for_full_surah(verse_range)
        #end
      end

      filter_ids
    end

    def filter_ids_for_full_surah(verse_range)
      surah, _from, _to = verse_range.process_range

      if surah
        Qr::Filter.where(chapter_id: surah, verse_number_from: nil, verse_number_to: nil).pluck(:id)
      else
        []
      end
    end
  end
end