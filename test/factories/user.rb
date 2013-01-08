FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| n.eql?(1) ? "user@b.com" : "user#{n}@b.com"}
    password  "password"    
		after(:build) { |user| user.class.skip_callback(:create, :after, :create_empty_ratings) }
		factory :user_create_empty_ratings do
			after(:create) { |user| user.create_empty_ratings }
		end
	end
end
