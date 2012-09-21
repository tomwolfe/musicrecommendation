# MusicRecommendation

Music recommender system using the [cofi_cost gem] (https://github.com/tomwolfe/cofi_cost) collaborative filtering playground.

It's still under development.

## What works:

User login
Users Rating tracks/showing average rating for track/current_user_rating for track

## What does not:

recommendations:
  seeing how i'll be tying this in with the Musicbrainz.org database which currently
  contains ~11 million tracks this will probably be an expensive computation
  (11,000,000^num_users_with_ratings). So while it would be nice to rerun the
  conjugate-gradient-descent algorithm to update the Predictions table each
  time a user adds a rating it would probably be best to have a cron job that
  runs once a day that updates the Predictions table. This might be solvable
  with mini-batch-conjugate-gradient-descent, but I don't think an online
  algorithm is best here since it does not seem like a great idea to throw
  away user ratings.
