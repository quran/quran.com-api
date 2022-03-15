# == Schema Information
# Schema version: 20220311202850
#
# Table name: qr_post_filters
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  filter_id  :integer
#  post_id    :integer
#
# Indexes
#
#  index_qr_post_filters_on_post_id_and_filter_id  (post_id,filter_id)
#
class Qr::PostFilter < QrRecord
  belongs_to :post, class_name: 'Qr::Post'
  belongs_to :filter, class_name: 'Qr::Filter'
end
