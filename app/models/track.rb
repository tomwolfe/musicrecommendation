class Track < ActiveRecord::Base
  has_many :ratings
  has_many :raters, :through => :ratings, :source => :users
  
  QUERY = MusicBrainz::Webservice::Query.new
  
  def self.find_in_musicbrainz(existing_tracks, track_name, artist_name)
  	ar_mb_tracks = Array.new
  	# requires at least one field not be empty
  	# FIXME: I'm not sure how to validate a form not backed by a model
  	unless track_name.empty? && artist_name.empty?
  		mb_tracks = QUERY.get_tracks(MusicBrainz::Webservice::TrackFilter.new(title: track_name, artist: artist_name, limit: 10)).to_a
  		mb_tracks.delete_if { |track| existing_tracks.include? track.entity.id.to_mbid }
  		mb_tracks.each do |track|
  			entity = track.entity
				ar_mb_tracks << Track.new(name: entity.title, artist_name: entity.artist.to_s, mb_id: entity.id.uuid, releases: entity.releases.to_a.to_s)
			end
  	end
  	return ar_mb_tracks
  end
end
