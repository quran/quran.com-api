require 'rails_helper'

RSpec.describe Search::Query, type: :model do
  context 'query is english' do
    let(:search) { Search::Query.new('noah') }

    it 'should be noah and not arabic' do
      expect(search.query.query).to eql('noah')
      expect(search.query.is_arabic?).to be_falsy
    end

    it 'should use translation indices' do
      expect(search.indices).to eql(['trans*', 'text-font'])
    end

    it 'should have have text, text.stemmed' do
      expect(search.fields_val).to eql(['text^1.6', 'text.stemmed'])
    end
  end

  context 'query is arabic' do
    let(:search) { Search::Query.new('الحمد لله رب العالمين') }

    it 'query is arabic' do
      expect(search.query.query).to eql('الحمد لله رب العالمين')
      expect(search.query.is_arabic?).to be_truthy
    end

    it 'should use text font and tafsir indices' do
      expect(search.indices).to eql(['text-font', 'tafsir'])
    end

    it 'should have have text, text.lemma, and others' do
      expect(search.fields_val).to eql([
        'text^5',
        'text.lemma^4',
        'text.stem^3',
        'text.root^1.5',
        'text.lemma_clean^3',
        'text.stem_clean^2',
        'text.ngram^2',
        'text.stemmed^2'
      ])
    end
  end
end
