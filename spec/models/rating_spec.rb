require_relative '../spec_helper'

# oddly enough, gsl from git does not get installed in /var/lib/gems/... with
# 'bundle install'. I had to manually clone git repo and build/install it

describe Rating do
  before :each do
  	Rating.skip_callback(:save, :after, :generate_predictions)
   	@rating = FactoryGirl.create(:rating)
    @track2 = FactoryGirl.create(:track)
  end
  context 'prediction stuff' do
  	before :each do
  		@prediction_table = NArray[[0.8],[0.7]]
  		CofiCost.any_instance.stub(:predictions).and_return(@prediction_table)
			CofiCost.any_instance.stub(:min_cost).and_return(nil)
		end
		describe '#generate_predictions' do
			it 'sets the predictions' do
				@rating.generate_predictions(1)
			  Rating.pluck(:prediction).should eq([0.8, 0.7])
			end
		end
		context 'generate_predictions support methods' do
			before :each do
				@user_count, @track_count = User.count, Track.count
		  	@ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
		  end
			describe '#build_rating_table' do
				it 'returns a multi-dim array holding the ratings for users and tracks (0.0 for unrated tracks)' do
					rating_table = @rating.build_rating_table(@ratings, @user_count, @track_count)
					rating_table.should be == NArray[ [ 1.0 ], [0.0] ]
				end
			end
			describe '#add_predictions' do
				it 'adds the generated predictions to the database' do
					@rating.add_predictions(@prediction_table, @user_count, @track_count)
					Rating.pluck(:prediction).should eq([0.8, 0.7])
				end
			end
		end
	end
	describe '#average_rating' do
	  it 'sets the associated tracks average_rating' do
	    @rating.track.average_rating.should eq(1.0)
	  end
	end
end
