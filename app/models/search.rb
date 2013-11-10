class Search
	# Rails 4 fixme: just need   include ActiveModel::Model   w/o initializer
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :track_name, :artist_name

	validates_presence_of :track_name, :artist_name

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end if attributes
	end

	def persisted?
		false
	end

	def find_in_musicbrainz(existing_tracks)
		mb_tracks = MusicBrainz::Recording.search(@track_name, @artist_name)
		mb_tracks.delete_if { |track| existing_tracks.include? track[:id] }
		ar_mb_tracks = create_tracks_array(mb_tracks)
	end
	
	def create_tracks_array(mb_tracks)
		ar_mb_tracks = Array.new
		if mb_tracks.respond_to?(:each)
			mb_tracks.each do |track|
				ar_mb_tracks << Track.new({name: track[:title], artist_name: track[:artist], mb_id: track[:id], releases: track[:releases].to_s.tr('"', '')}, without_protection: true)
			end
		end
 		ar_mb_tracks
	end
end
