# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V3::VersesController, type: :routing do
  describe 'routing' do
    it 'should not support edit verse route' do
      expect(get: 'api/v3/chapters/1/verses/1/edit').not_to be_routable
    end

    it 'routes to #index' do
      expect(get: 'api/v3/chapters/1/verses').symbolize_keys.to route_to(format: 'json', controller: 'v3/verses', action: 'index', chapter_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/v3/chapters/1/verses/1').to route_to(format: 'json', controller: 'v3/verses', action: 'show', chapter_id: '1', id: '1')
    end
  end
end
