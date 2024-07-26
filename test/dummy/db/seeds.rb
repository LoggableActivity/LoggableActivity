# frozen_string_literal: true

puts 'Seeding database...'
company_names = ['Alpha Inc.', 'Beta LLC', 'Gamma Corp', 'Delta Ltd', 'Epsilon GmbH']

company_names.each do |name|
  Company.find_or_create_by(name:)
end
# Example user data
users_data = [
  { first_name: 'Alice', last_name: 'Johnson', email: 'alice.johnson@example.com', age: 28, user_type: 'customer' },
  { first_name: 'Bob', last_name: 'Smith', email: 'bob.smith@example.com', age: 32, user_type: 'customer' },
  { first_name: 'Charlie', last_name: 'Brown', email: 'charlie.brown@example.com', age: 24, user_type: 'employee' },
  { first_name: 'Dana', last_name: 'White', email: 'dana.white@example.com', age: 29, user_type: 'customer' },
  { first_name: 'Eli', last_name: 'Green', email: 'eli.green@example.com', age: 35, user_type: 'employee' }
]

users_data.each do |user_data|
  User.find_or_create_by(email: user_data[:email]) do |user|
    user.first_name = user_data[:first_name]
    user.last_name = user_data[:last_name]
    user.age = user_data[:age]
    user.user_type = user_data[:user_type]
  end
end

cars_data = [
  { brand: 'Toyota', age: 18, color: 'blue' },
  { brand: 'Ford', age: 12, color: 'red' },
  { brand: 'Chevrolet', age: 5, color: 'green' },
  { brand: 'Honda', age: 3, color: 'yellow' }
]

cars_data.each do |car_data|
  Car.find_or_create_by(brand: car_data[:brand]) do |car|
    car.age = car_data[:age]
    car.color = car_data[:color]
  end
end

hats_data = [
  { user: User.first, color: 'red' },
  { user: User.second, color: 'blue' },
  { user: User.third, color: 'green' }
]

hats_data.each do |hat_data|
  Hat.find_or_create_by(color: hat_data[:color], user: hat_data[:user])
end
