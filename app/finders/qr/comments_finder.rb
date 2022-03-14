module Qr
  class CommentsFinder < BaseFinder
    def comments(post_id:, include_author:, include_replies:)
      comments = Qr::Comment.where(post_id: post_id)

      paginate comments.includes(eager_load_resources(author: include_author, recent_replies: include_replies))
    end

    def find(id, include_author:, include_replies:)
      Qr::Comment.includes(eager_load_resources(author: include_author, recent_replies: include_replies)).find(id)
    end

    def replies(id, include_author:)
      comments = Qr::Comment.where(parent_id: id)

      paginate comments.includes(eager_load_resources(author: include_author))
    end

    protected

    def eager_load_resources(author:, recent_replies: false, replies: false)
      eager_load = []

      if author
        eager_load << :author
      end

      if recent_replies
        eager_load << (author ? {recent_replies: :author} : :recent_replies)
      end

      if replies
        eager_load << (author ? {replies: :author} : :replies)
      end

      eager_load
    end
  end
end