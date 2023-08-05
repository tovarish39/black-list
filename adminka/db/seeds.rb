# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


data = [
    {telegram_id:'65788123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'ru', status:'not_scamer:default'},
    {telegram_id:'123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'ru', status:'not_scamer:default'},
    {telegram_id:'123412342143', username:"gfdsdfsgsadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'ru', status:'scamer:managed_by_moderator'},
    {telegram_id:'123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'ru', status:'not_scamer:default'},
    {telegram_id:'5678123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'ru', status:'not_scamer:default'},
    {telegram_id:'123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'en', status:'not_scamer:managed_by_admin'},
    {telegram_id:'123412342143', username:"gfgfdgfdssadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'en', status:'not_scamer:default'},
    {telegram_id:'5687123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'en', status:'not_scamer:default'},
    {telegram_id:'123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'en', status:'verified:managed_by_admin'},
    {telegram_id:'123412342143', username:"sadfsadf", first_name:'asdfsdf', last_name:'xcvbvcb', lg:'en', status:'not_scamer:default'},
]



data.each do |obj|
    User.create(
        telegram_id:obj[:telegram_id], 
        username:obj[:username], 
        first_name:obj[:first_name], 
        last_name:obj[:last_name], 
        lg:obj[:lg], 
        status:obj[:status]
    )
end