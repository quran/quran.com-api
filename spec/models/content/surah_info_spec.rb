# frozen_string_literal: true

# == Schema Information
#
# Table name: surah_infos
#
#  id                :integer          not null, primary key
#  language_code     :string
#  description       :text
#  surah_id          :integer
#  content_source    :text
#  short_description :text
#

require "rails_helper"

RSpec.describe Content::SurahInfo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
