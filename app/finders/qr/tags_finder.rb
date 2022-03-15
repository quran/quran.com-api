module Qr
  class TagsFinder < BaseFinder
    def tags(name: nil)
      records = Qr::Tag.where(approved: true).order('posts_count DESC')

      if name
        records = records.where('name like ?', "#{name}%")
      end

      paginate(records)
    end
  end
end