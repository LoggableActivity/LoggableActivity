require 'rails_helper'

RSpec.describe "demo/journals/show", type: :view do
  before(:each) do
    assign(:demo_journal, Demo::Journal.create!(
      patient: nil,
      doctor: nil,
      title: "Title",
      body: "MyText",
      state: "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/State/)
  end
end
