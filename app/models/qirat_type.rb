# == Schema Information
#
# Table name: qirat_types
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class QiratType < ApplicationRecord
end
