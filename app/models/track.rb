class Track < ActiveRecord::Base
  has_many :ratings, dependent: :destroy
  has_many :raters, :through => :ratings, :source => :users
  attr_accessible :ratings_attributes
  accepts_nested_attributes_for :ratings, allow_destroy: true
  
  QUERY = MusicBrainz::Webservice::Query.new
  
  def self.find_in_musicbrainz(existing_tracks, track_name, artist_name)
  	# requires at least one field not be empty
  	# FIXME: I'm not sure how to validate a form not backed by a model
  	unless track_name.empty? && artist_name.empty?
  		mb_tracks = QUERY.get_tracks(MusicBrainz::Webservice::TrackFilter.new(title: track_name, artist: artist_name, limit: 10)).to_a
  		mb_tracks.delete_if { |track| existing_tracks.include? track.entity.id.to_mbid }
  		ar_mb_tracks = create_array_of_tracks(mb_tracks)
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
  
  def self.get_track_from_musicbrainz(mbid)
  	track = QUERY.get_track_by_id(mbid)
  	Track.new({name: track.title, artist_name: track.artist.to_s, mb_id: track.id.uuid, releases: track.releases.to_a.to_s}, without_protection: true)
  end
  
end
