# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'demo/products/show', type: :view do
  before(:each) do
    assign(:demo_product, Demo::Product.create!(
                            name: 'Name',
                            part_number: 'Part Number',
                            price: '9.99'
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Part Number/)
    expect(rendered).to match(/9.99/)
  end
end
