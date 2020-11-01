# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3::AudioFilesController, type: :controller do

  CHAPTER_ID = 1
  VERSE_ID = 1
  ID = 1

  describe 'GET #index' do
    before do
      Chapter.create!(id: CHAPTER_ID)
      lemma = VerseLemma.create!(id: ID)
      root = VerseRoot.create!(id: ID)
      stem = VerseStem.create!(id: ID)
      Verse.create!(id: VERSE_ID, chapter_id: CHAPTER_ID, verse_root: root, verse_lemma: lemma, verse_stem: stem)
    end

    it 'returns http success' do
      get :index, params: { chapter_id: CHAPTER_ID, verse_id: VERSE_ID }
      expect(response).to have_http_status(:ok)
    end
  end
end
