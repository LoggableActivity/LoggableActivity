require 'rails_helper'

RSpec.describe "demo/journals/edit", type: :view do
  let(:demo_journal) {
    Demo::Journal.create!(
      patient: nil,
      doctor: nil,
      title: "MyString",
      body: "MyText",
      state: "MyString"
    )
  }

  before(:each) do
    assign(:demo_journal, demo_journal)
  end

  it "renders the edit demo_journal form" do
    render

    assert_select "form[action=?][method=?]", demo_journal_path(demo_journal), "post" do

      assert_select "input[name=?]", "demo_journal[patient_id]"

      assert_select "input[name=?]", "demo_journal[doctor_id]"

      assert_select "input[name=?]", "demo_journal[title]"

      assert_select "textarea[name=?]", "demo_journal[body]"

      assert_select "input[name=?]", "demo_journal[state]"
    end
  end
end
