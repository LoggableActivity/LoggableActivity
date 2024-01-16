require 'rails_helper'

RSpec.describe "demo/clubs/new", type: :view do
  let(:addresses) { FactoryBot.create_list(:demo_address, 2) }

  before(:each) do
    assign(:demo_club, Demo::Club.new(
      name: "MyString"
    ))
    assign(:addresses, addresses)     
  end

  it "renders new demo_club form" do
    render

    assert_select "form[action=?][method=?]", demo_clubs_path, "post" do

      assert_select "input[name=?]", "demo_club[name]"
    end
  end
end
