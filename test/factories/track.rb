FactoryGirl.define do
	factory :track do
		sequence(:name) {|n| n.eql?(1) ? "Freebird" : "Freebird#{n}"}
		artist_name  "Lynyrd Skynyrd"
		# 100 is the initial value (to keep it a valid mb_id)
		sequence(:mb_id, 100) {|n| "9a0589c9-7dc9-4c5c-9fda-af6cd8630#{n}"}
		after(:build) { |track| track.class.skip_callback(:create, :after, :create_empty_ratings) }
		factory :track_create_empty_ratings do
			after(:create) { |track| track.create_empty_ratings }
		end
	end
end
