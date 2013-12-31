require_relative '../spec_helper'

describe Rating do
  before :each do
    Track.any_instance.stub(:must_be_in_musicbrainz).and_return(true)
    @rating = FactoryGirl.create(:rating)
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
