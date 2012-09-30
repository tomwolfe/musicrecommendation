When /I should see new user items/ do
    Then %Q(I should see "Thanks for joining")
      And %Q(I should see signed in items)
end

When /I should( not)?see signed in items/ do |negate|
  Then %Q(I should#{negate} see the link "Sign Out" in the "header" section)
  negate ? find('#user_header').should_not have_link('Sign In') : find('#user_header').should have_link('Sign In')
  negate ? find('#user_header').should_not have_link('Join') : find('#user_header').should have_link('Join')
  negate ? page.should have_content('Get personalized') : page.should have_no_content('Get personalized')
  Then %Q(I should#{negate} see "Top Recommended Tracks")
  Then %Q(I should#{negate} see the link "Search for a track to rate")
  Then %Q(I should#{negate} see "Your Most Recent Ratings")
end
