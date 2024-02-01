# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::JournalsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/demo/journals').to route_to('demo/journals#index')
    end

    it 'routes to #new' do
      expect(get: '/demo/journals/new').to route_to('demo/journals#new')
    end

    it 'routes to #show' do
      expect(get: '/demo/journals/1').to route_to('demo/journals#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/demo/journals/1/edit').to route_to('demo/journals#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/demo/journals').to route_to('demo/journals#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/demo/journals/1').to route_to('demo/journals#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/demo/journals/1').to route_to('demo/journals#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/demo/journals/1').to route_to('demo/journals#destroy', id: '1')
    end
  end
end
