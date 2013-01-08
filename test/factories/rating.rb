FactoryGirl.define do
  factory :rating do
    value '1'
    user
    track
		after(:build) do |rating|
			rating.class.skip_callback(:save, :after, :generate_predictions)
			rating.class.skip_callback(:save, :after, :average_rating)
		end
		factory :rating_generate_predictions do
			after(:save) { |rating| rating.generate_predictions }
		end
		factory :rating_average_rating do
			after(:save) { |rating| rating.average_rating }
		end
		factory :rating_generate_predictions_and_average_rating do
			after(:save) do |rating|
				rating.generate_predictions
				rating.average_rating
			end
		end
	end
end
