# frozen_string_literal: true

module Demo
  class Product < ApplicationRecord
    include Loggable::Activities
  end
end
