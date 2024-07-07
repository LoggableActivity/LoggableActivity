# frozen_string_literal: true

class Hat < ApplicationRecord
  include LoggableActivity::Hooks
  belongs_to :user
end
