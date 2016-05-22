require 'rails_helper'

RSpec.describe V2::OptionsController, type: :controller do
  describe 'GET #audio' do
    it 'returns list of audio options' do
      list = Audio::Recitation.list_audio_options
      get :audio

      expect(response_json.count).to eql(list.as_json.count)
      expect(response_json.map{ |audio| audio['id'] }.sort).to eql(list.map(&:id).sort)
    end
  end

  describe 'GET #content' do
    it 'returns list of content options' do
      list = Content::Resource.list_content_options
      get :content

      expect(response_json.count).to eql(list.as_json.count)
      expect(response_json.map{ |content| content['id'] }).to eql(list.map(&:id))
    end
  end

  describe 'GET #quran' do
    it 'returns list of quran options' do
      list = Content::Resource.list_quran_options
      get :quran

      expect(response_json.count).to eql(list.as_json.count)
      expect(response_json.map{ |quran| quran['id'] }).to eql(list.map(&:id))
    end
  end

  describe 'GET #language' do
    it 'returns list of language options' do
      list = Content::Resource.list_language_options
      get :language

      expect(response_json.count).to eql(list.as_json.count)
      expect(response_json.map{ |language| language['id'] }).to eql(list.map(&:id))
    end
  end

  describe 'GET #default' do
    it 'returns default options' do
      get :default

      expect(response_json['content']).to eql([21])
      expect(response_json['quran']).to eql(1)
      expect(response_json['audio']).to eql(1)
    end
  end
end
