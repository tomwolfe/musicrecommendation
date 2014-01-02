require_relative '../spec_helper'

describe Prediction do
  before :each do
    Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
    @prediction = FactoryGirl.create(:prediction)
    @rating = @prediction.rating
    @prediction_table = NArray[[0.8]]
    CofiCost.any_instance.stub(:predictions).and_return(@prediction_table)
    CofiCost.any_instance.stub(:min_cost).and_return(nil)
  end
  describe '#generate_predictions' do
    it 'sets the predictions' do
      @prediction.generate_predictions(1)
      Prediction.pluck(:value).should eq([1.0])
    end
  end
  context 'generate_predictions support methods' do
    before :each do
      @prediction.instance_variable_set(:@user_count, 1)
      @prediction.instance_variable_set(:@track_count, 2)
      @ratings = Rating.select([:user_id, :track_id, :value]).where("value IS NOT NULL")
    end
    describe '#build_rating_table' do
      it 'returns a multi-dim array holding the ratings for users and tracks (0.0 for unrated tracks)' do
        rating_table = @prediction.build_rating_table(@ratings)
        rating_table.should be == NArray[ [ 1.0 ], [0.0] ]
      end
    end
    describe '#add_predictions' do
      before :each do
        @prediction.instance_variable_set(:@rating, @rating)
        @prediction.instance_variable_set(:@predictions, @prediction_table)
      end
      it 'calls #add_prediction_logic' do
        @prediction.should_receive(:add_prediction_logic)
        @prediction.add_predictions
      end
      it 'adds the generated predictions to the database' do
        @prediction.add_predictions
        Prediction.first.value.should eq(1.0)
      end
    end
    describe '#add_prediction_logic' do
      # Prediction factory defaults to a value of 1
      it 'updates the prediction if it has changed by more than 0.2' do
        @prediction.instance_variable_set(:@predictions, NArray[[0.7]])
        @prediction.instance_variable_set(:@rating, @rating)
        @prediction.add_prediction_logic
        expect(Prediction.first.value).to eq(0.7)
      end
      it 'does not update the prediction if it has changed by less than 0.2' do
        @prediction.instance_variable_set(:@predictions, NArray[[0.9]])
        @prediction.instance_variable_set(:@rating, @rating)
        @prediction.add_prediction_logic
        expect(Prediction.first.value).to eq(1.0)
      end
      it 'sets the prediction if it is currently nil' do
        @prediction = FactoryGirl.create(:nil_prediction)
        @rating = @prediction.rating
        @prediction.instance_variable_set(:@predictions, NArray[[0.0, 0.0],[0.0, 0.9]])
        @prediction.instance_variable_set(:@rating, @rating)
        @prediction.add_prediction_logic
        expect(Prediction.find(2).value).to eq(0.9)
      end
    end
  end
end
