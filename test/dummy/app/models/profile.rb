# frozen_string_literal: true

class Profile < ApplicationRecord
  include LoggableActivity::Hooks
  belongs_to :user
end
