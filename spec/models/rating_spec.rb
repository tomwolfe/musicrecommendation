require_relative '../spec_helper'

describe Rating do
	before :each do
		Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
		@rating = FactoryGirl.create(:rating)
	end
	context 'prediction stuff' do
		before :each do
			@prediction_table = NArray[[0.8]]
			CofiCost.any_instance.stub(:predictions).and_return(@prediction_table)
			CofiCost.any_instance.stub(:min_cost).and_return(nil)
		end
		describe '#generate_predictions' do
			it 'sets the predictions' do
				@rating.generate_predictions(1)
				Rating.pluck(:prediction).should eq([0.8])
			end
		end
		context 'generate_predictions support methods' do
			before :each do
				@rating.instance_variable_set(:@user_count, 1)
				@rating.instance_variable_set(:@track_count, 2)
				@ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
			end
			describe '#build_rating_table' do
				it 'returns a multi-dim array holding the ratings for users and tracks (0.0 for unrated tracks)' do
					rating_table = @rating.build_rating_table(@ratings)
					rating_table.should be == NArray[ [ 1.0 ], [0.0] ]
				end
			end
			describe '#add_predictions' do
				before :each do
					@rating.instance_variable_set(:@rating, @rating)
					@rating.instance_variable_set(:@predictions, @prediction_table)
				end
				it 'adds the generated predictions to the database' do
					@rating.add_predictions
					Rating.pluck(:prediction).should eq([0.8])
				end
			end
			describe '#add_prediction_logic' do
				before :each do
					@rating.instance_variable_set(:@predictions, @prediction_table)
				end
				it 'updates the prediction if it has changed by more than 0.2' do
					@rating.should_receive(:add_prediction).with(0.8)
					@rating.prediction = 1.1
					@rating.instance_variable_set(:@rating, @rating)
					@rating.add_prediction_logic
				end
				it 'does not updated the prediction if it has changed by less than 0.2' do
					@rating.should_not_receive(:add_prediction)
					@rating.prediction = 0.9
					@rating.instance_variable_set(:@rating, @rating)
					@rating.add_prediction_logic
				end
				it 'sets the prediction if it is currently nil' do
					@rating.should_receive(:add_prediction).with(0.8)
					@rating.prediction = nil
					@rating.instance_variable_set(:@rating, @rating)
					@rating.add_prediction_logic
				end
			end
		end
	end
	describe '.create_empty_ratings' do
		# 1 tracks, 1 user and 1 rating available before each
		it 'creates Track.count new ratings after adding a user' do
			FactoryGirl.create(:user_create_empty_ratings)
			Rating.count.should eq(2)
		end
		it 'creates User.count new ratings after adding a track' do
			FactoryGirl.create(:track_create_empty_ratings)
			Rating.count.should eq(2)
		end
	end
	describe '#average_rating' do
		it 'sets the associated tracks average_rating' do
			@rating.average_rating
			@rating.track.average_rating.should eq(1.0)
		end
	end
end
