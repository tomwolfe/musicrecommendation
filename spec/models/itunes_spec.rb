require_relative '../spec_helper'

describe Itunes do
	before :each do
		# FIXME: ugly, should probably use a json fixture or somesuch.
		@tunes = [{"wrapperType"=>"track", "kind"=>"song", "artistId"=>37771, "collectionId"=>255169, "trackId"=>255076, "artistName"=>"Local H", "collectionName"=>"As Good as Dead", "trackName"=>"Bound for the Floor", "collectionCensoredName"=>"As Good as Dead", "trackCensoredName"=>"Bound for the Floor", "artistViewUrl"=>"https://itunes.apple.com/us/artist/local-h/id37771?uo=4", "collectionViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "trackViewUrl"=>"https://itunes.apple.com/us/album/bound-for-the-floor/id255169?i=255076&uo=4", "previewUrl"=>"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a", "artworkUrl30"=>"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg", "artworkUrl60"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg", "artworkUrl100"=>"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg", "collectionPrice"=>7.99, "trackPrice"=>1.29, "releaseDate"=>"1996-04-16T07:00:00Z", "collectionExplicitness"=>"notExplicit", "trackExplicitness"=>"notExplicit", "discCount"=>1, "discNumber"=>1, "trackCount"=>13, "trackNumber"=>3, "trackTimeMillis"=>222960, "country"=>"USA", "currency"=>"USD", "primaryGenreName"=>"Rock"}]
		@track = FactoryGirl.build(:track)
		ITunesSearchAPI.stub(:search).and_return(@tunes)
	end
	
	describe '.itunes_data(track)' do
		it 'returns an array of itunes data' do
			Itunes.itunes_data(@track).should == @tunes
		end
		it 'calls ITunesSearchAPI' do
			ITunesSearchAPI.should_receive(:search)
			Itunes.itunes_data(@track)
		end
	end

	describe '.itunes_affiliate_data(track)' do
		it 'should call .itunes_links' do
			#Itunes.should_receive(:itunes_data)
			Itunes.should_receive(:itunes_data).and_return(@tunes)
			Itunes.itunes_affiliate_data(@track)
		end
		it 'should call .modify_urls(hash)' do
			Itunes.should_receive(:modify_urls)
			Itunes.itunes_affiliate_data(@track)
		end
		it 'returns an array of itunes links with associated affiliate tracking' do
			Itunes.itunes_affiliate_data(@track).to_s.should == "[{\"wrapperType\"=>\"track\", \"kind\"=>\"song\", \"artistId\"=>37771, \"collectionId\"=>255169, \"trackId\"=>255076, \"artistName\"=>\"Local H\", \"collectionName\"=>\"As Good as Dead\", \"trackName\"=>\"Bound for the Floor\", \"collectionCensoredName\"=>\"As Good as Dead\", \"trackCensoredName\"=>\"Bound for the Floor\", \"artistViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Fartist%252Flocal-h%252Fid37771%253Fuo%253D4%2526partnerId%253D30\", \"collectionViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30\", \"trackViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30\", \"previewUrl\"=>\"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a\", \"artworkUrl30\"=>\"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg\", \"artworkUrl60\"=>\"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg\", \"artworkUrl100\"=>\"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg\", \"collectionPrice\"=>7.99, \"trackPrice\"=>1.29, \"releaseDate\"=>\"1996-04-16T07:00:00Z\", \"collectionExplicitness\"=>\"notExplicit\", \"trackExplicitness\"=>\"notExplicit\", \"discCount\"=>1, \"discNumber\"=>1, \"trackCount\"=>13, \"trackNumber\"=>3, \"trackTimeMillis\"=>222960, \"country\"=>\"USA\", \"currency\"=>\"USD\", \"primaryGenreName\"=>\"Rock\"}]"
		end
	end

	describe '.escape_link(link)' do
		it 'calls escape' do
			CGI.should_receive(:escape).twice
			Itunes.escape_link("https://")
		end
		it 'double escapes the link' do
			Itunes.escape_link(@tunes.first["trackViewUrl"]).should == "https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30"
		end
	end

	describe '.modify_urls(hash)' do
		it 'adds the AFFILIATE_WRAPPER and double escapes the link with partnerId appended' do
			Itunes.modify_urls(@tunes.first).to_s.should == "{\"wrapperType\"=>\"track\", \"kind\"=>\"song\", \"artistId\"=>37771, \"collectionId\"=>255169, \"trackId\"=>255076, \"artistName\"=>\"Local H\", \"collectionName\"=>\"As Good as Dead\", \"trackName\"=>\"Bound for the Floor\", \"collectionCensoredName\"=>\"As Good as Dead\", \"trackCensoredName\"=>\"Bound for the Floor\", \"artistViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Fartist%252Flocal-h%252Fid37771%253Fuo%253D4%2526partnerId%253D30\", \"collectionViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30\", \"trackViewUrl\"=>\"http://click.linksynergy.com/fs-bin/stat?id=#{Itunes::AFFILIATE_ID}&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=https%253A%252F%252Fitunes.apple.com%252Fus%252Falbum%252Fbound-for-the-floor%252Fid255169%253Fi%253D255076%2526uo%253D4%2526partnerId%253D30\", \"previewUrl\"=>\"http://a1301.phobos.apple.com/us/r1000/069/Music/9e/8b/ac/mzm.vykyoexn.aac.p.m4a\", \"artworkUrl30\"=>\"http://a1.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.30x30-50.jpg\", \"artworkUrl60\"=>\"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.60x60-50.jpg\", \"artworkUrl100\"=>\"http://a5.mzstatic.com/us/r1000/000/Features/0a/df/97/dj.kdcejnrw.100x100-75.jpg\", \"collectionPrice\"=>7.99, \"trackPrice\"=>1.29, \"releaseDate\"=>\"1996-04-16T07:00:00Z\", \"collectionExplicitness\"=>\"notExplicit\", \"trackExplicitness\"=>\"notExplicit\", \"discCount\"=>1, \"discNumber\"=>1, \"trackCount\"=>13, \"trackNumber\"=>3, \"trackTimeMillis\"=>222960, \"country\"=>\"USA\", \"currency\"=>\"USD\", \"primaryGenreName\"=>\"Rock\"}"
		end
		it 'calls .escape_link' do
			Itunes.should_receive(:escape_link).exactly(3).times
			#Itunes.should_receive(:escape_link).with(kind_of(String))
			Itunes.modify_urls(@tunes.first)
		end
	end
end
