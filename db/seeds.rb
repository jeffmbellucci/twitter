# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ActiveRecord::Base.transaction do
  jeff = User.create!(:username => "Jeff", :user_id => 123)
  sam = User.create!(:username => "Sam", :user_id => 456)

  Follow.create!(:follower_id => 1, :leader_id => 2)

end