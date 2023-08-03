# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)



user = User.create(telegram_id:'123', username:'sadf', first_name:'qwer', last_name:'-', lg:'ru', state_aasm:'start')
user.complaints.create()