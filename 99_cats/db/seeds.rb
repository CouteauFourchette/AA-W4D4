# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([ { user_name: 'user1', password: 'password' }, { user_name: 'user2', password: 'password' }])
cats = []
10.times { cats << Cat.create( { birth_date: Faker::Date.backward(14),
    name: Faker::Cat.name,
    color: Cat::CAT_COLORS.sample,
    sex: ['M', 'F'].sample,
    description: Faker::Hacker.say_something_smart,
    user_id: users.sample.id } ) }
