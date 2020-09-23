# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3::VersesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/verses').to route_to('verses#index')
    end

    it 'routes to #new' do
      expect(get: '/verses/new').to route_to('verses#new')
    end

    it 'routes to #show' do
      expect(get: '/verses/1').to route_to('verses#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/verses/1/edit').to route_to('verses#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/verses').to route_to('verses#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/verses/1').to route_to('verses#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/verses/1').to route_to('verses#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/verses/1').to route_to('verses#destroy', id: '1')
    end
  end
end
