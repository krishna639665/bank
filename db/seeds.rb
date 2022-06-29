# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = User.create!(id: 1, email: 'admin@admin.com', password: 'admin@123', password_confirmation: 'admin@123', username: 'Admin')
user.add_role :admin
Account.create(id: 1, first_name: "admin",gender: "male",address: "mohali",age: 22, nomine_name: "admin",phone_number: "6396654658", 
	adhar_number: "678754658765", account_type: "current_account", account_number: "123456789123",
	account_ifsc: "SWISS0001102",account_balance: 10000000, user_id: 1, status: true)
    