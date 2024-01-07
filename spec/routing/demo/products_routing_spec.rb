# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::ProductsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/demo/products').to route_to('demo/products#index')
    end

    it 'routes to #new' do
      expect(get: '/demo/products/new').to route_to('demo/products#new')
    end

    it 'routes to #show' do
      expect(get: '/demo/products/1').to route_to('demo/products#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/demo/products/1/edit').to route_to('demo/products#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/demo/products').to route_to('demo/products#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/demo/products/1').to route_to('demo/products#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/demo/products/1').to route_to('demo/products#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/demo/products/1').to route_to('demo/products#destroy', id: '1')
    end
  end
end
