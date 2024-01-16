# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/demo/clubs', type: :request do
  let(:valid_attributes) do
    { name: 'Adventures Club' }
  end

  let(:addresses) { FactoryBot.create_list(:demo_address, 2) }

  let(:invalid_attributes) do
    { name: nil }
  end

  before(:each) do
    addresses
    user = FactoryBot.create(:user)
    sign_in user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Demo::Club.create! valid_attributes
      get demo_clubs_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      club = Demo::Club.create! valid_attributes
      get demo_club_url(club)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_demo_club_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      club = Demo::Club.create! valid_attributes
      get edit_demo_club_url(club)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Demo::Club' do
        expect do
          post demo_clubs_url, params: { demo_club: valid_attributes }
        end.to change(Demo::Club, :count).by(1)
      end

      it 'redirects to the created demo_club' do
        post demo_clubs_url, params: { demo_club: valid_attributes }
        expect(response).to redirect_to(demo_club_url(Demo::Club.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Demo::Club' do
        expect do
          post demo_clubs_url, params: { demo_club: invalid_attributes }
        end.to change(Demo::Club, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post demo_clubs_url, params: { demo_club: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Runners Club' }
      end

      let(:addresses) { FactoryBot.create_list(:demo_address, 2) }

      before(:each) do
        addresses
        user = FactoryBot.create(:user)
        sign_in user
      end

      it 'updates the requested demo_club' do
        club = Demo::Club.create! valid_attributes
        patch demo_club_url(club), params: { demo_club: new_attributes }
        club.reload
        expect(club.name).to eq(new_attributes[:name])
      end

      it 'redirects to the demo_club' do
        club = Demo::Club.create!(valid_attributes)
        patch demo_club_url(club), params: { demo_club: new_attributes }
        club.reload
        expect(response).to redirect_to(demo_club_url(club))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        club = Demo::Club.create! valid_attributes
        patch demo_club_url(club), params: { demo_club: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested demo_club' do
      club = Demo::Club.create! valid_attributes
      expect do
        delete demo_club_url(club)
      end.to change(Demo::Club, :count).by(-1)
    end

    it 'redirects to the demo_clubs list' do
      club = Demo::Club.create! valid_attributes
      delete demo_club_url(club)
      expect(response).to redirect_to(demo_clubs_url)
    end
  end
end
