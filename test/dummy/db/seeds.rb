puts 'Seeding database...'
company_names = ["Alpha Inc.", "Beta LLC", "Gamma Corp", "Delta Ltd", "Epsilon GmbH"]

company_names.each do |name|
  Company.find_or_create_by(name: name)
end
# Example user data
users_data = [
  { first_name: "Alice", last_name: "Johnson", email: "alice.johnson@example.com", age: 28, user_type: "customer" },
  { first_name: "Bob", last_name: "Smith", email: "bob.smith@example.com", age: 32, user_type: "customer" },
  { first_name: "Charlie", last_name: "Brown", email: "charlie.brown@example.com", age: 24, user_type: "employee" },
  { first_name: "Dana", last_name: "White", email: "dana.white@example.com", age: 29, user_type: "customer" },
  { first_name: "Eli", last_name: "Green", email: "eli.green@example.com", age: 35, user_type: "employee" }
]

users_data.each do |user_data|
  User.find_or_create_by(email: user_data[:email]) do |user|
    user.first_name = user_data[:first_name]
    user.last_name = user_data[:last_name]
    user.age = user_data[:age]
    user.user_type = user_data[:user_type]
    # If you have a company_id you want to assign, you can do it here. For example:
    # user.company_id = Company.find_by(name: "Some Company").id
  end
end