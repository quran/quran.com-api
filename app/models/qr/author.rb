# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_authors
#
#  id               :bigint           not null, primary key
#  avatar_url       :string
#  bio              :text
#  comments_count   :integer          default(0)
#  followers_count  :integer
#  followings_count :integer
#  name             :string
#  posts_count      :integer          default(0)
#  user_type        :integer
#  username         :string
#  verified         :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_qr_authors_on_user_type  (user_type)
#  index_qr_authors_on_username   (username)
#  index_qr_authors_on_verified   (verified)
#

#  id         :bigint           not null, primary key
#  avatar_url :string
#  bio        :string
#  name       :string
#  user_type  :string
#  verified   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Qr::Author < QrRecord
  has_many :comments, class_name: 'Qr::Comment'
  has_many :posts, class_name: 'Qr::Post'

  scope :verified, -> { where verified: true }
  enum user_type: { scholar: 1, student: 2 }

  def self.with_username_or_id(values)
    username_or_ids = values.tr('@', '').split(',')
    ids = username_or_ids.select { |part| part =~ /\d+/ }
    usernames = username_or_ids - ids

    with_ids = Qr::Author.where(id: ids)
    Qr::Author.where(username: usernames).or(with_ids)
  end
end
