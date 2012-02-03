# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Track.delete_all
track_one = Track.create(name: 'Okay', artist_name: 'Local H')
track_two = Track.create(name: 'Again', artist_name: 'Alice in Chains')
track_three = Track.create(name: 'Sour Girl', artist_name: 'Stone Temple Pilots')

User.delete_all
user_one = User.create(username: 'foo', email: 'foo@example.com', password: 'password', password_confirmation: 'password')
user_two = User.create(username: 'bar', email: 'bar@example.com', password: 'psswd', password_confirmation: 'psswd')

Rating.delete_all
rating_one = Rating.new
rating_one.track_id = track_one.id
rating_one.user_id = user_one.id
rating_one.value = 1
rating_one.save

rating_two = Rating.new
rating_two.track_id = track_two.id
rating_two.user_id = user_one.id
rating_two.value = 4
rating_two.save

rating_three = Rating.new
rating_three.track_id = track_one.id
rating_three.user_id = user_two.id
rating_three.value = 4
rating_three.save
