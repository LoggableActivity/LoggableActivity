# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Demo::ActivityLogs', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      user = FactoryBot.create(:user) # Assuming you have a user factory
      sign_in user
      get '/demo/activity_logs'
      expect(response).to have_http_status(:success)
    end
  end
end
