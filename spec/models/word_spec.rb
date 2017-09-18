# == Schema Information
#
# Table name: words
#
#  id             :integer          not null, primary key
#  verse_id       :integer
#  chapter_id     :integer
#  position       :integer
#  text_madani    :text
#  text_indopak   :text
#  text_simple    :text
#  verse_key      :string
#  page_number    :integer
#  class_name     :string
#  line_number    :integer
#  code_dec       :integer
#  code_hex       :string
#  code_hex_v3    :string
#  code_dec_v3    :integer
#  char_type_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pause_name     :string
#  audio_url      :string
#  image_blob     :text
#  image_url      :string
#  location       :string
#  topic_id       :integer
#  token_id       :integer
#  char_type_name :string
#

require 'rails_helper'

RSpec.describe Word, type: :model do
  describe 'associations' do
    it 'belongs_to verse' do
      verse = described_class.reflect_on_association(:verse)
      expect(verse.macro).to eq :belongs_to
    end

    it 'belongs_to char_type' do
      char_type = described_class.reflect_on_association(:char_type)
      expect(char_type.macro).to eq :belongs_to
    end

    it 'belongs_to topic' do
      topic = described_class.reflect_on_association(:topic)
      expect(topic.macro).to eq :belongs_to
    end

    it 'belongs_to token' do
      token = described_class.reflect_on_association(:token)
      expect(token.macro).to eq :belongs_to
    end

    it 'has_many translations' do
      translations = described_class.reflect_on_association(:translations)
      expect(translations.macro).to eq :has_many
    end

    it 'has_many transliterations' do
      transliterations = described_class.reflect_on_association(:transliterations)
      expect(transliterations.macro).to eq :has_many
    end

    it 'has_many word_lemmas' do
      word_lemmas = described_class.reflect_on_association(:word_lemmas)
      expect(word_lemmas.macro).to eq :has_many
    end

    it 'has_many lemmas' do
      lemmas = described_class.reflect_on_association(:lemmas)
      expect(lemmas.macro).to eq :has_many
    end

    it 'has_many word_stems' do
      word_stems = described_class.reflect_on_association(:word_stems)
      expect(word_stems.macro).to eq :has_many
    end

    it 'has_many stems' do
      stems = described_class.reflect_on_association(:stems)
      expect(stems.macro).to eq :has_many
    end

    it 'has_many word_roots' do
      word_roots = described_class.reflect_on_association(:word_roots)
      expect(word_roots.macro).to eq :has_many
    end

    it 'has_many roots' do
      roots = described_class.reflect_on_association(:roots)
      expect(roots.macro).to eq :has_many
    end

    it 'has_one audio' do
      audio = described_class.reflect_on_association(:audio)
      expect(audio.macro).to eq :has_one
    end

    it 'has_one word_corpus' do
      word_corpus = described_class.reflect_on_association(:word_corpus)
      expect(word_corpus.macro).to eq :has_one
    end
  end

  describe 'dynamic associations' do
    before(:each) do
      Array.new(3) { |i| create(:language, name: "english_#{i}", iso_code: "en_#{i}") }
    end

    let(:languages) { Language.all }

    it 'has_many translations' do
      languages.each do |language|
        translations = described_class.reflect_on_association("#{language.iso_code}_translations".to_sym)
        expect(translations.macro).to eq :has_many
      end
    end

    it 'has_many transliterations' do
      languages.each do |language|
        transliterations = described_class.reflect_on_association("#{language.iso_code}_transliterations".to_sym)
        expect(transliterations.macro).to eq :has_many
      end
    end
  end

  describe 'default scope' do
    let!(:word_one) {create(:word, position: 2)}
    let!(:word_two) {create(:word, position: 1)}

    it 'returns all words in order by ascending position' do
      words = Word.all

      expect(words).to match_array([word_one, word_two])
      expect(words.first).to eq(word_two)
      expect(words.first).to eq(word_two)
    end
  end
end
