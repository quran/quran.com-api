# == Schema Information
#
# Table name: quran.word_font
#
#  resource_id  :integer          not null, primary key
#  ayah_key     :text             not null, primary key
#  position     :integer          not null, primary key
#  word_id      :integer
#  page_num     :integer          not null
#  line_num     :integer          not null
#  code_dec     :integer          not null
#  code_hex     :text             not null
#  char_type_id :integer          not null
#

require 'rails_helper'

RSpec.describe Quran::WordFont, type: :model do
  let(:word_font) { Quran::WordFont.new }
  describe '#as_json' do
      it 'calls the correct methods to build the hash' do
        expect(word_font).to receive(:class_name)
        expect(word_font).to receive(:code)
        expect(word_font).to receive(:translation)
        expect(word_font).to receive(:transliteration)
        expect(word_font).to receive(:arabic)
        word_font.as_json
    end
  end
end
