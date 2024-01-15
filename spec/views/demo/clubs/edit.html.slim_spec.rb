require 'rails_helper'

RSpec.describe "demo/clubs/edit", type: :view do
  let(:demo_club) {
    Demo::Club.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:demo_club, demo_club)
  end

  it "renders the edit demo_club form" do
    render

    assert_select "form[action=?][method=?]", demo_club_path(demo_club), "post" do

      assert_select "input[name=?]", "demo_club[name]"
    end
  end
end
