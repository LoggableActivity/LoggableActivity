class Profile < ApplicationRecord
  include LoggableActivity::Hooks
  belongs_to :user
end
