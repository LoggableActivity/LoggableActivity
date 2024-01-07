# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'home/index.html.slim', type: :view do
  context 'when user is signed in' do
    before do
      user = instance_double('User', email: 'user@example.com')
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
    end

    it 'displays a sign out link and the user email' do
      render
      expect(rendered).to include 'You are signed in as user@example.com'
      expect(rendered).to have_link 'Sign out', href: destroy_user_session_path
    end
  end

  context 'when user is not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it 'displays a sign in link' do
      render
      expect(rendered).to have_link 'Sign in', href: new_user_session_path
    end
  end
end
