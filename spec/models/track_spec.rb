require_relative '../spec_helper'

def update_mbids
	@all_track_mbids = Track.pluck(:mb_id)
end

describe Track do
	before :each do
		@title = "Bound for the Floor"
		@track = MusicBrainz::Model::Track.new("http://musicbrainz.org/track/ea0ad976-5750-4885-9f33-2c656dfc4a42", @title)
		@track.artist = "local h"
		@tunes = [{"trackViewUrl" => "https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4"}]
		@mr_track = FactoryGirl.build(:track)
	end
	
	describe '#must_be_in_musicbrainz' do
		it 'creates no errors given a valid track' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: @title, mb_id: @track.id.uuid).should be_valid
		end
		it 'raises an InvalidMBIDError given an invalid mb_id' do
			FactoryGirl.build(:track, mb_id: "hi")
			lambda { FactoryGirl.build(:track, mb_id: "hi").valid?.should raise_error(MusicBrainz::Model::InvalidMBIDError) }
		end
		it 'creates errors given a valid mb_id but non-matching name' do
			Track::QUERY.stub(:get_track_by_id).and_return(@track)
			FactoryGirl.build(:track, name: "wrong name", mb_id: @track.id.uuid).should_not be_valid
		end
	end

	describe '#itunes_links' do
		before :each do
			ITunesSearchAPI.stub(:search).and_return(@tunes)
		end
		it 'returns an array of itunes links' do
			@mr_track.itunes_links.should == [@tunes.first["trackViewUrl"]]
		end
	end

	describe '#itunes_affiliate_links' do
		before :each do
			@should_return = ["http://click.linksynergy.com/fs-bin/stat?id=CBIMl*gYY/8&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"]
			ITunesSearchAPI.stub(:search).and_return(@tunes)
		end
		it 'should call #itunes_links' do
			@mr_track.should_receive(:itunes_links).and_return(@should_return)
			@mr_track.itunes_affiliate_links
		end
		it 'should call .escape_link(link)' do
			Track.should_receive(:escape_link)
			@mr_track.itunes_affiliate_links
		end
		it 'returns an array of itunes links with associated affiliate tracking' do
			@mr_track.itunes_affiliate_links.should == @should_return
		end
	end

	describe '.escape_link(link)' do
		it 'calls escape' do
			CGI.should_receive(:escape).twice
			Track.escape_link("https://")
		end
		it 'double escapes the link' do
			Track.escape_link(@tunes.first["trackViewUrl"]).should == "https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"
		end
	end
end
