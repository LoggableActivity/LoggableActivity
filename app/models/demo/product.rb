# frozen_string_literal: true

module Demo
  class Product < ApplicationRecord
    include ActivityLogger
  end
end
