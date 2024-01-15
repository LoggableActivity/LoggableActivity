require 'rails_helper'

RSpec.describe "demo/clubs/show", type: :view do
  before(:each) do
    assign(:demo_club, Demo::Club.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
