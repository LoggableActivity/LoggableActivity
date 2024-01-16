require 'rails_helper'

RSpec.describe "demo/clubs/index", type: :view do
  before(:each) do
    assign(:demo_clubs, [
      Demo::Club.create!(
        name: "Crossfit 101"
      ),
      Demo::Club.create!(
        name: "Horses and Hounds"
      )
    ])
  end

  it "renders a list of demo/clubs" do
    render
    cell_selector = 'tr>td'
    assert_select cell_selector, text: Regexp.new("Crossfit 101".to_s), count: 1
    assert_select cell_selector, text: Regexp.new("Horses and Hounds".to_s), count: 1
  end
end
