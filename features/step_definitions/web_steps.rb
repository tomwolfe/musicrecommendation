module WithinHelpers
  def format_path(path)
    path.gsub!(/\s/,'_').downcase!
  end
end
World(WithinHelpers)

When /I am on the "(*.)" page/ do |page|
  page=format_path(page)
  eval("visit #{page}_path")
end

When /I click on "(*.)"/ do |link|
  click_link(link)
end

When /I should be on the "(*.)" page/ do |page|
  page=format_path(page)
  current_path.should == eval("#{page}_path")
end

When /I should see "(*.)"/ do |see|
  page.should have_content(see)
end

When /the following (*.) exist/ do |things, things_table|
  thing=things[0..-2].capitalize # remove plurality
  things_table.hashes.each do |thing_table|
    eval("#{thing}.create!(thing_table)")
    # each returned element will be a hash whose key is the table header.
  end
end
