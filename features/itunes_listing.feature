Feature: View links to buy a track on iTunes

	Background: I am signed in
		Given a track exists
			And I am on the itunes track page for the first track

	Scenario: I should see a link to purchase the track on itunes
		# TODO: change to affiliate link						
		Then I should see the link "As Good as Dead" pointing to "http://click.linksynergy.com/fs-bin/stat?id=EZoLiqecFIY&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"
