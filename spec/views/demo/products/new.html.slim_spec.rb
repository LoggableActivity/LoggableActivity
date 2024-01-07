require 'rails_helper'

RSpec.describe "demo/products/new", type: :view do
  before(:each) do
    assign(:demo_product, Demo::Product.new(
      name: "MyString",
      part_number: "MyString",
      price: "9.99"
    ))
  end

  it "renders new demo_product form" do
    render

    assert_select "form[action=?][method=?]", demo_products_path, "post" do

      assert_select "input[name=?]", "demo_product[name]"

      assert_select "input[name=?]", "demo_product[part_number]"

      assert_select "input[name=?]", "demo_product[price]"
    end
  end
end
