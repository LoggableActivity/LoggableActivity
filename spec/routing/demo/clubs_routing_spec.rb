# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::ClubsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/demo/clubs').to route_to('demo/clubs#index')
    end

    it 'routes to #new' do
      expect(get: '/demo/clubs/new').to route_to('demo/clubs#new')
    end

    it 'routes to #show' do
      expect(get: '/demo/clubs/1').to route_to('demo/clubs#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/demo/clubs/1/edit').to route_to('demo/clubs#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/demo/clubs').to route_to('demo/clubs#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/demo/clubs/1').to route_to('demo/clubs#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/demo/clubs/1').to route_to('demo/clubs#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/demo/clubs/1').to route_to('demo/clubs#destroy', id: '1')
    end
  end
end
