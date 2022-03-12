# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_comments
#
#  id         :bigint           not null, primary key
#  body       :string
#  html_body  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :string
#  post_id    :string
#
class Qr::Comment < QrRecord
  belongs_to :author, class_name: 'Qr::Author'
  belongs_to :post, class_name: 'Qr::Post'
end
