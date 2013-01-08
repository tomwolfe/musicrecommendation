FactoryGirl.define do
	factory :track do
		sequence(:name) {|n| n.eql?(1) ? "Freebird" : "Freebird#{n}"}
		artist_name  "Lynyrd Skynyrd"
		after(:build) { |track| track.class.skip_callback(:create, :after, :create_empty_ratings) }
		factory :track_create_empty_ratings do
			after(:create) { |track| track.create_empty_ratings }
		end
	end
end
