# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'demo/clubs/edit', type: :view do
  let(:demo_club) { Demo::Club.create!(name: 'MyString') }
  let(:addresses) { FactoryBot.create_list(:demo_address, 2) }

  before(:each) do
    assign(:demo_club, demo_club)
    assign(:addresses, addresses)
  end

  it 'renders the edit demo_club form' do
    render

    assert_select 'form[action=?][method=?]', demo_club_path(demo_club), 'post' do
      assert_select 'input[name=?]', 'demo_club[name]'
    end
  end
end
