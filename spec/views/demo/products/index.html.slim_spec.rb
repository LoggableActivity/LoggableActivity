# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'demo/products/index', type: :view do
  before(:each) do
    assign(:demo_products, [
             Demo::Product.create!(
               name: 'Name',
               part_number: 'Part Number',
               price: '9.99'
             ),
             Demo::Product.create!(
               name: 'Name',
               part_number: 'Part Number',
               price: '9.99'
             )
           ])
  end

  it 'renders a list of demo/products' do
    render
    cell_selector = 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Part Number'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('9.99'.to_s), count: 2
  end
end
