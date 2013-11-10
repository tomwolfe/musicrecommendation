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

	def must_be_in_musicbrainz
		mbtrack = MusicBrainz::Track.find(mb_id)
		#	http://musicbrainz.org/ws/2/recording/9a0589c9-7dc9-4c5c-9fda-af6cd863095c

		errors.add(:name, "name #{name} (#{mbtrack.title}) not the same as the track with mb_id #{mb_id} (#{mbtrack.recording_id}) in MusicBrainz") if (mbtrack.title != name)
		errors.add(:mb_id, "mb_id #{mb_id} not found in Musicbrainz") if (mbtrack.recording_id != mb_id)
	end

	def create_empty_ratings
		Rating.create_empty_ratings("User", self.id)
	end
end
