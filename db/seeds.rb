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
puts '-------------------- Seeding data ---------------------'

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
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'Bob',
    last_name: 'Smith',
    age: 32,
    bio: 'I am politician with a drinking problem',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.first.id,
    user_type: 'Patient'
  },
  {
    email: 'house@example.com',
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'DR.',
    last_name: 'House',
    age: 32,
    bio: 'I am a famous actress',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.first.id,
    user_type: 'Doctor'
  },
  {
    email: 'alice@example.com',
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'Alice',
    last_name: 'Springs',
    age: 32,
    bio: 'I am a famous actress',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.first.id,
    user_type: 'Patient'
  },
  {
    email: 'jane@example.com',
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'Jane',
    last_name: 'Doe',
    age: 28,
    bio: 'Im a selebrity on rehab',
    demo_address_id: Demo::Address.second.id,
    demo_club_id: Demo::Club.second.id,
    user_type: 'Patient'
  },
  {
    email: 'emily@example.com',
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'Emily',
    last_name: 'Johnson',
    age: 32,
    bio: 'I am a really private person',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.third.id,
    user_type: 'Patient'
  },
  {
    email: 'michael-brown@example.com',
    password: 'password1234',
    password_confirmation: 'password1234',
    first_name: 'Michael',
    last_name: 'Brown',
    age: 32,
    bio: 'I am a dangerous kriminal killer',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.fourth.id,
    user_type: 'Doctor'
  },
  {
    email: 'max@example.com',
    password: 'iL9Ac%&w2mqD$TKl.kXW}e-L1%',
    password_confirmation: 'iL9Ac%&w2mqD$TKl.kXW}e-L1%',
    first_name: 'Max',
    last_name: 'Grønlund',
    age: 32,
    bio: 'I am a system administrator',
    demo_address_id: Demo::Address.first.id,
    demo_club_id: Demo::Club.fourth.id,
    user_type: 'Admin'
  }
]

User.delete_all
users.each do |user|
  next if User.find_by(email: user[:email]).present?

  User.create!(user)
end

journals = [
  {
    patient_id: User.find_by(email: 'emily@example.com').id,
    doctor_id: User.find_by(email: 'michael-brown@example.com').id,
    title: 'Private information',
    body: 'Lumbersexual mumblecore same, ennui enamel pin affogato gentrify bruh taxidermy',
    state: 'pending'
  },
  {
    patient_id: User.find_by(email: 'max@example.com').id,
    doctor_id: User.find_by(email: 'jane@example.com').id,
    title: 'Please dont tell anyone',
    body: 'Waistcoat copper mug grailed, hella farm-to-table tbh pitchfork four loko austin.',
    state: 'pending'
  },
  {
    patient_id: User.find_by(email: 'jane@example.com').id,
    doctor_id: User.find_by(email: 'michael-brown@example.com').id,
    title: 'Confidential',
    body: 'Gastropub ascot lyft banh mi gatekeep, sustainable retro listicle cloud bread.',
    state: 'pending'
  }
]

Demo::Journal.delete_all
journals.each do |journal|
  Demo::Journal.find_or_create_by!(journal)
end
puts '------------------ Seeding data done -------------------'
