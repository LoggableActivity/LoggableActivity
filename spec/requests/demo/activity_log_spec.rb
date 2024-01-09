# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Demo::ActivityLogs', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/demo/activity_logs'
      expect(response).to have_http_status(:success)
    end
  end
end
