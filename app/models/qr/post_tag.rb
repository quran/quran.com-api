# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_post_tags
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  tag_id     :integer
#
# Indexes
#
#  index_qr_post_tags_on_post_id_and_tag_id  (post_id,tag_id)
#
class Qr::PostTag < QrRecord
  belongs_to :post, class_name: 'Qr::Post'
  belongs_to :tag, class_name: 'Qr::Tag'
end
