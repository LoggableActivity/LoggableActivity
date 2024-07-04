# frozen_string_literal: true

module LoggableActivity
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
