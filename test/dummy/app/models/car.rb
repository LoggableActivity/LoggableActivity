# frozen_string_literal: true

class Car < ApplicationRecord
  include LoggableActivity::Hooks
end
