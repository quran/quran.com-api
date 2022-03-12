# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_authors
#
#  id         :bigint           not null, primary key
#  avatar_url :string
#  bio        :string
#  name       :string
#  user_type  :string
#  verified   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Qr::Author < QrRecord
  has_many :comments, class_name: 'Qr::Comment'
  has_many :posts, class_name: 'Qr::Post'
end
