# == Schema Information
# Schema version: 20220411000741
#
# Table name: qr_posts
#
#  id               :bigint           not null, primary key
#  body             :text
#  comments_count   :integer          default(0)
#  html_body        :text
#  language_name    :string
#  likes_count      :integer          default(0)
#  post_type        :integer
#  ranking_weight   :integer
#  referenced_ayahs :json
#  url              :string
#  verified         :boolean
#  views_count      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  author_id        :integer
#  language_id      :integer
#  room_id          :integer
#
# Indexes
#
#  index_qr_posts_on_author_id       (author_id)
#  index_qr_posts_on_language_id     (language_id)
#  index_qr_posts_on_post_type       (post_type)
#  index_qr_posts_on_ranking_weight  (ranking_weight)
#  index_qr_posts_on_verified        (verified)
#
class Qr::Post < QrRecord
  belongs_to :author, class_name: 'Qr::Author'
  belongs_to :room, class_name: 'Qr::Room', optional: true

  has_many :post_filters, class_name: 'Qr::PostFilter'
  has_many :filters, through: :post_filters, class_name: 'Qr::Filter'
  has_many :post_tags, class_name: 'Qr::PostTag'
  has_many :tags, through: :post_tags, class_name: 'Qr::Tag'
  has_many :comments, class_name: 'Qr::Comment'
  has_many :recent_comments, -> {order('created_at DESC').limit(10)}, class_name: 'Qr::Comment'

  enum room_post_status: {
    as_room:  1,
    publicly: 2,
    only_members: 3
  }
end
