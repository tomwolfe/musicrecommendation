When /^I rate the track as "(.*)"$/ do |rating_value|
  user = User.find(1)
  track = Track.find(1)
  # a little sloppier than one "create!" line
  # foreign keys w/ mass assignment with attr_accessable
  # does not work, probably for security?
  # not sure if something like:
  # Rating.create!(user, track, rating_value) exists
  # maybe: user.ratings.create!(track.id)
  rating = Rating.new
  rating.user_id, rating.track_id, rating.value = user.id, track.id, rating_value
  rating.save!
end

When /^I should see items pertaining to having rated a track$/ do
  artist = Track.find(1).artist_name
  Then %Q(I should see "#{artist}")
    And %Q(I should see "More Ratings")
    And %Q(I should see "More Predictions")
end
