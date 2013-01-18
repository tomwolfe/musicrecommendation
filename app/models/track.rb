class Track < ActiveRecord::Base
	has_many :ratings, dependent: :destroy
	has_many :raters, :through => :ratings, :source => :users
	attr_accessible :ratings_attributes, :name, :artist_name, :mb_id, :releases
	accepts_nested_attributes_for :ratings, allow_destroy: true
	# FIXME: (identical issue in User model) creates User.count ratings
	# would like to pass a block (I can't get it to work w/ skip_callback,
	# I can only get it to work with a method name)
	# after_create {|track| Rating.create_empty_ratings("User", track.id)}
	after_create :create_empty_ratings
	validate :must_be_in_musicbrainz

	QUERY = MusicBrainz::Webservice::Query.new
	
	def self.find_in_musicbrainz(existing_tracks, track_name, artist_name)
		# requires at least one field not be empty
		# FIXME: I'm not sure how to validate a form not backed by a model
		# maybe create a separate search model.
		unless track_name.empty? && artist_name.empty?
			mb_tracks = QUERY.get_tracks(MusicBrainz::Webservice::TrackFilter.new(title: track_name, artist: artist_name, limit: 10)).to_a
			mb_tracks.delete_if { |track| existing_tracks.include? track.entity.id.uuid }
			ar_mb_tracks = create_tracks_array(mb_tracks)
		end
	end
	
	def self.create_tracks_array(mb_tracks)
		ar_mb_tracks = Array.new
		if mb_tracks.respond_to?(:each)
			mb_tracks.each do |track|
					entity = track.entity
					ar_mb_tracks << Track.new({name: entity.title, artist_name: entity.artist.to_s, mb_id: entity.id.uuid, releases: entity.releases.to_a.to_s}, without_protection: true)
			end
		end
		return ar_mb_tracks
	end

	def must_be_in_musicbrainz
		# FIXME (not sure of best solution, ideas below that won't work w/ reasons)
		# would like to do the following but it just returns the tracks title
		# with no way to get the artist/etc (using as temp partial solution)
		mbtrack = QUERY.get_track_by_id(mb_id)
		#	http://musicbrainz.org/ws/1/track/9a0589c9-7dc9-4c5c-9fda-af6cd863095c?type=xml

		# would like the following, however, what's returned seems to be stochastic
		#tracks = QUERY.get_tracks(MusicBrainz::Webservice::TrackFilter.new(title: track_hash[:track_name], artist: track_hash[:artist_name], limit: 10)).to_a
		#tracks.select! { |track| track_hash[:mb_id] == track.entity.id.uuid }
		#track = tracks.first.entity

		# could also do an expires_at: 1.day.from_now in create_tracks_array, but
		# that'd mess up some logic for creating ratings/predictions...
		if (mbtrack.title != name)
			errors.add(:name, "name #{name} (#{mbtrack.title}) not the same as the track with mb_id #{mb_id} (#{mbtrack.id.uuid}) in MusicBrainz")
		end
		if (mbtrack.id.uuid != mb_id)
			errors.add(:mb_id, "mb_id #{mb_id} not found in Musicbrainz")
		end
	end
	
	def create_empty_ratings
		Rating.create_empty_ratings("User", self.id)
	end

end
