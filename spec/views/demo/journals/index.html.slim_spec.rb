require 'rails_helper'

RSpec.describe "demo/journals/index", type: :view do
  before(:each) do
    assign(:demo_journals, [
      Demo::Journal.create!(
        patient: nil,
        doctor: nil,
        title: "Title",
        body: "MyText",
        state: "State"
      ),
      Demo::Journal.create!(
        patient: nil,
        doctor: nil,
        title: "Title",
        body: "MyText",
        state: "State"
      )
    ])
  end

  it "renders a list of demo/journals" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("State".to_s), count: 2
  end
end
