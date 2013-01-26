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
		end
	end

	def persisted?
		false
	end

	def find_in_musicbrainz(existing_tracks)
		mb_tracks = Track::QUERY.get_tracks(MusicBrainz::Webservice::TrackFilter.new(title: @track_name, artist: @artist_name, limit: 10)).to_a
		mb_tracks.delete_if { |track| existing_tracks.include? track.entity.id.uuid }
		ar_mb_tracks = create_tracks_array(mb_tracks)
	end
	
	def create_tracks_array(mb_tracks)
		ar_mb_tracks = Array.new
		if mb_tracks.respond_to?(:each)
			mb_tracks.each do |track|
				entity = track.entity
				ar_mb_tracks << Track.new({name: entity.title, artist_name: entity.artist.to_s, mb_id: entity.id.uuid, releases: entity.releases.to_a.to_s}, without_protection: true)
			end
		end
 		ar_mb_tracks
	end
end
