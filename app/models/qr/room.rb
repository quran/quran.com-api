# == Schema Information
# Schema version: 20220325102524
#
# Table name: qr_rooms
#
#  id         :bigint           not null, primary key
#  name       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Qr::Room < QrRecord
end
