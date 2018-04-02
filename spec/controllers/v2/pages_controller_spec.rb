# frozen_string_literal: true

require "rails_helper"

RSpec.describe V2::PagesController, type: :controller do
  describe "GET #show" do
    describe "getting pages" do
      before { get :show, id: 1, content: [19], audio: 8 }

      it "returns http success and returns corret number of ayahs" do
        expect(response).to have_http_status(:success)
        expect(response_json.count).to be > 0
      end

      it "returns correct ayah attributes" do
        expect(response_json.all? { |ayah| ayah["content"].count == 1 }).to be_truthy
        expect(response_json.all? { |ayah| ayah["words"].present? }).to be_truthy
        expect(response_json.all? { |ayah| ayah["audio"].present? }).to be_truthy
      end
    end

    describe "order of ayahs" do
      it "should order by surah and ayah" do
        get :show,  id: 604, content: [19], audio: 8  # Page 604 has 3 Surahs

        response_json.each_with_index do |ayah, index|
          unless index == response_json.count - 1
            next_ayah = response_json[index + 1]
            # If the next ayah has less ayah_num than current, it must be different surah
            if ayah["ayah_num"] > next_ayah["ayah_num"]
              expect(ayah["surah_id"]).not_to eql(next_ayah["surah_id"])
            else
              expect(ayah["ayah_num"] + 1).to eql(next_ayah["ayah_num"])
            end
          end
        end
      end
    end

    describe "when invalid page number" do
      it "should return not found when more than 604" do
        get :show, id: 605, content: [19], audio: 8
        expect(response).to have_http_status(:not_found)
      end

      it "should return not found when more than 0" do
        get :show, id: 0, content: [19], audio: 8
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
