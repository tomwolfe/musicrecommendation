class Track < ActiveRecord::Base
	has_many :ratings, dependent: :destroy
	has_many :raters, :through => :ratings, :source => :users
	attr_accessible :name, :artist_name, :mb_id, :releases
	# FIXME: (identical issue in User model) creates User.count ratings
	# would like to pass a block (I can't get it to work w/ skip_callback,
	# I can only get it to work with a method name)
	# after_create {|track| Rating.create_empty_ratings("User", track.id)}
	after_create :create_empty_ratings
	validate :must_be_in_musicbrainz
	validates :name, :artist_name, :mb_id, presence: true
	validates :mb_id, uniqueness: true

	QUERY = MusicBrainz::Webservice::Query.new

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

		errors.add(:name, "name #{name} (#{mbtrack.title}) not the same as the track with mb_id #{mb_id} (#{mbtrack.id.uuid}) in MusicBrainz") if (mbtrack.title != name)
		
		errors.add(:mb_id, "mb_id #{mb_id} not found in Musicbrainz") if (mbtrack.id.uuid != mb_id)
	end

	def create_empty_ratings
		Rating.create_empty_ratings("User", self.id)
	end
end
