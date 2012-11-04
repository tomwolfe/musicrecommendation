class TracksController < ApplicationController
	skip_before_filter :authorize, only: [:show]

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # GET /tracks/search
  def search
  	# using = rather than LIKE so it won't have to compare every record
  	@tracks = Track.where("name = ? OR artist_name = ?", params[:track_name], params[:artist_name]).limit(20)
  	@tracks_in_musicbrainz_and_not_db = Track.find_in_musicbrainz(@tracks.pluck(:mb_id), params[:track_name], params[:artist_name])
  end
end
