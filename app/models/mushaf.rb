# frozen_string_literal: true

# == Schema Information
#
# Table name: mushafs
#
#  id                :bigint           not null, primary key
#  default_font_name :string
#  description       :text
#  is_default        :boolean          default(FALSE)
#  lines_per_page    :integer
#  name              :string           not null
#
# Indexes
#
#  index_mushafs_on_is_default  (is_default)
#
class Mushaf < ApplicationRecord
end
