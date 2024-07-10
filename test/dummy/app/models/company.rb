class Company < ApplicationRecord
  include LoggableActivity::Hooks
  has_many :users, dependent: :nullify
end
