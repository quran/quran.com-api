module Qr
  class AuthorsFinder < BaseFinder
    VALID_FILTERS = ['scholars', 'students', 'verified', 'all']

    def authors(filter: nil)
      records = if VALID_FILTERS.include?(filter)
                  if 'all' == filter
                    Qr::Author
                  else
                    Qr::Author.send(filter)
                  end.order('posts_count DESC')
                else
                  Qr::Author.verified.order('posts_count DESC')
                end

      paginate records
    end

    def followings(author_id)
      # TODO
      paginate Qr::Author.none
    end

    def followers(author_id)
      #TODO
      paginate Qr::Author.none
    end
  end
end