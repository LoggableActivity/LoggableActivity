# frozen_string_literal: true

module Demo
  class UserProfile < ApplicationRecord
    # belongs_to :user
    belongs_to :user, class_name: 'User', foreign_key: :user_id
  end
end
