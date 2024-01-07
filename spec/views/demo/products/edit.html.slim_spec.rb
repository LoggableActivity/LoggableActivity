# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'demo/products/edit', type: :view do
  let(:demo_product) do
    Demo::Product.create!(
      name: 'MyString',
      part_number: 'MyString',
      price: '9.99'
    )
  end

  before(:each) do
    assign(:demo_product, demo_product)
  end

  it 'renders the edit demo_product form' do
    render

    assert_select 'form[action=?][method=?]', demo_product_path(demo_product), 'post' do
      assert_select 'input[name=?]', 'demo_product[name]'

      assert_select 'input[name=?]', 'demo_product[part_number]'

      assert_select 'input[name=?]', 'demo_product[price]'
    end
  end
end
