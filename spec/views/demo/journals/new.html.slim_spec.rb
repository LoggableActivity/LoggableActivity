require 'rails_helper'

RSpec.describe "demo/journals/new", type: :view do
  before(:each) do
    assign(:demo_journal, Demo::Journal.new(
      patient: nil,
      doctor: nil,
      title: "MyString",
      body: "MyText",
      state: "MyString"
    ))
  end

  it "renders new demo_journal form" do
    render

    assert_select "form[action=?][method=?]", demo_journals_path, "post" do

      assert_select "input[name=?]", "demo_journal[patient_id]"

      assert_select "input[name=?]", "demo_journal[doctor_id]"

      assert_select "input[name=?]", "demo_journal[title]"

      assert_select "textarea[name=?]", "demo_journal[body]"

      assert_select "input[name=?]", "demo_journal[state]"
    end
  end
end
