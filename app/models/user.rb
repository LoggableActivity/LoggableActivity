# frozen_string_literal: true

class User < ApplicationRecord
  include ActivityLogger
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :demo_address, class_name: 'Demo::Address', foreign_key: :demo_address_id, optional: true
end
