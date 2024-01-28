# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Loggable::Activity.destroy_all
Loggable::EncryptionKey.destroy_all
Loggable::Payload.destroy_all

products = [
  { name: 'Banana', price: 0.32, part_number: 'BANANA-1108' },
  { name: 'Skim-milk', price: 0.49, part_number: 'SKIM-MILK-2208' },
  { name: 'Eggs 6 stk.', price: 2.49, part_number: 'EGGS-3308' },
  { name: 'Bread', price: 3.29, part_number: 'BREAD-4408' }
]

Demo::Product.delete_all
products.each do |product|
  Demo::Product.find_or_create_by!(product)
end

addresses = [
  { street: 'Kongens gate 1', city: 'Oslo', country: 'Norway', postal_code: '0153' },
  { street: 'Store kongensgade', city: 'København', country: 'Denmark', postal_code: '1264' },
  { street: 'Vestergade', city: 'Aarhus', country: 'Denmark', postal_code: '8000' },
  { street: 'Lystrup Centervej', city: 'Lystrup', country: 'Denmark', postal_code: '8520' }
]

Demo::Address.destroy_all
addresses.each do |address|
  Demo::Address.find_or_create_by!(address)
end

clubs = [
  { name: 'Lions Club', demo_address_id: Demo::Address.first.id },
  { name: 'Kitcat', demo_address_id: Demo::Address.second.id },
  { name: 'Monkey Bar', demo_address_id: Demo::Address.third.id },
  { name: 'Tropical Lounge', demo_address_id: Demo::Address.fourth.id }
]

Demo::Club.destroy_all
clubs.each do |club|
  Demo::Club.find_or_create_by!(club)
end

users = [
  {
    email: 'bob@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Bob',
    last_name: 'Smith',
    age: 32,
    bio: 'I am politician with a drinking problem',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.first.id,
    role: 'Patient'
  },
  {
    email: 'jane@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Jane',
    last_name: 'Doe',
    age: 28,
    bio: 'Im a selebrity on rehab',
    demo_address_id: Demo::Address.second.id,
    demo_club_id: Demo::Club.second.id,
    role: 'Patient'
  },
  {
    email: 'emily@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Emily',
    last_name: 'Johnson',
    age: 32,
    bio: 'I a really private person',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.third.id,
    role: 'Patient'
  },
  {
    email: 'michael-brown@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'michael',
    last_name: 'brown',
    age: 32,
    bio: 'i am a dangerous kriminal killer',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.fourth.id,
    role: 'Doctor'
  },
  {
    email: 'max@synthmax.dk',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Max',
    last_name: 'Grønlund',
    age: 32,
    bio: 'I am a system administrator',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.fourth.id,
    role: 'Admin'
  }
]

User.delete_all
users.each do |user|
  next if User.find_by(email: user[:email]).present?

  User.create!(user)
end
