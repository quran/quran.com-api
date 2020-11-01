# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3::VersesController, type: :routing do
  describe 'routing' do

    PREFIX = '/api/v3/chapters/1'

    it 'routes to #index' do
      expect(get: "#{PREFIX}/verses").to route_to('v3/verses#index', format: "json", chapter_id: "1")
    end

    it 'routes to #show' do
      expect(get: "#{PREFIX}/verses/1").to route_to('v3/verses#show', id: '1', format: "json", chapter_id: "1")
    end
  end
end
