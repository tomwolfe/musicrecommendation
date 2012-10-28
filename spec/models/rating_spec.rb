require 'spec_helper'

describe Rating do
  describe '#generate_predictions' do
    pending
    User.stub(:count).and_return(2)
    Track.stub(:count).and_return(2)
    Rating.stub(:select).and_return([mock(Rating, user_id: 1, track_id: 1, value: 1)]
  end
end
