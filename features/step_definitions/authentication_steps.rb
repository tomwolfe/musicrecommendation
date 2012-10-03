When /I should see new user items/ do
    Then %Q(I should see "Thanks for joining")
      And %Q(I should see signed in items)
end

When /I should( not)? see signed in items/ do |negate|
  Then %Q(I should#{negate} see the link "Sign Out" in the "header" section)
  negate ? eval('Then %Q(I should see the link "Sign In" in the "header" section)') : eval('Then %Q(I should not see the link "Sign In" in the "header" section)')
  negate ? eval('Then %Q(I should see the link "Join" in the "header" section)') : eval('Then %Q(I should not see the link "Join" in the "header" section)')
  negate ? eval('Then %Q(I should see "Get personalized")') : eval('Then %Q(I should not see "Get personalized")')
  Then %Q(I should#{negate} see "Top Recommended Tracks")
  Then %Q(I should#{negate} see the link "Search for a track to rate")
  Then %Q(I should#{negate} see "Your Most Recent Ratings")
end

When /^I sign in$/ do
  step %Q(a user exists)
  @current_user = User.find(1)
  cookies[:stub_user_id] = @current_user.id
end

When /^a (.*) exists$/ do |thing|
  FactoryGirl.create(thing.to_sym)
end
