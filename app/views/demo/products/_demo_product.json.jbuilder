# frozen_string_literal: true

json.extract! demo_product, :id, :name, :part_number, :price, :created_at, :updated_at
json.url demo_product_url(demo_product, format: :json)
