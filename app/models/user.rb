# frozen_string_literal: true

class User < ApplicationRecord
  include ActivityLogger
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :demo_address, class_name: 'Demo::Address', foreign_key: :demo_address_id, optional: true
  belongs_to :demo_club, class_name: 'Demo::Club', foreign_key: :demo_club_id, optional: true

  def name
    "#{first_name} #{last_name}"
  end
end
