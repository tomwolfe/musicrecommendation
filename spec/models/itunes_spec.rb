require_relative '../spec_helper'

describe Itunes do
	before :each do
		# FIXME: ugly, should probably use a json fixture or somesuch.
		@tunes = [{"wrapperType"=>"track", "kind"=>"song", "artistId"=>37771, "collectionId"=>255169, "trackId"=>255076, "artistName"=>"Local H", "collectionName"=>"As Good as Dead", "trackName"=>"Bound for the Floor", "collectionCensoredName"=>"As Good as Dead", "trackCensoredName"=>"Bound for the Floor", "artistViewUrl"=>"https://itunes.apple.com/us/artist/local-h/id37771?uo=4", "collectionViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "trackViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "previewUrl"=>"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a", "artworkUrl30"=>"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg", "artworkUrl60"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg", "artworkUrl100"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg", "collectionPrice"=>7.99, "trackPrice"=>1.29, "releaseDate"=>"1996-04-16T07:00:00Z", "collectionExplicitness"=>"notExplicit", "trackExplicitness"=>"notExplicit", "discCount"=>1, "discNumber"=>1, "trackCount"=>13, "trackNumber"=>3, "trackTimeMillis"=>222960, "country"=>"USA", "currency"=>"USD", "primaryGenreName"=>"Rock"}]
		@track = FactoryGirl.build(:track)
	end
	
	describe '#itunes_links' do
		before :each do
			ITunesSearchAPI.stub(:search).and_return(@tunes)
		end
		it 'returns an array of itunes links' do
			@track.itunes_links.should == [@tunes.first["trackViewUrl"]]
		end
	end

	describe '#itunes_affiliate_links' do
		before :each do
			@should_return = ["http://click.linksynergy.com/fs-bin/stat?id=CBIMl*gYY/8&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"]
			ITunesSearchAPI.stub(:search).and_return(@tunes)
		end
		it 'should call #itunes_links' do
			@track.should_receive(:itunes_links).and_return(@should_return)
			@track.itunes_affiliate_links
		end
		it 'should call .escape_link(link)' do
			Track.should_receive(:escape_link)
			@track.itunes_affiliate_links
		end
		it 'returns an array of itunes links with associated affiliate tracking' do
			@track.itunes_affiliate_links.should == @should_return
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
