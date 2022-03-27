# == Schema Information
# Schema version: 20220326180952
#
# Table name: qr_reported_issues
#
#  id             :bigint           not null, primary key
#  body           :text
#  email          :string
#  name           :string
#  synced_with_qr :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  comment_id     :integer
#  post_id        :integer
#
class Qr::ReportedIssue < ApplicationRecord
  validates :post_id,
            :body,
            :name,
            :email,
            presence: true
end
