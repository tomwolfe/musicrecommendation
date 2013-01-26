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

	def update
		@track = Track.find(params[:id])
		if @track.update_attributes(params[:track])
			redirect_to root_path, notice: 'Successfully updated track.'
		else
			redirect_to root_path, notice: 'Unable to update track.'
		end
	end
  
  # GET /tracks/search
  def search
		# should still use index even w/ LIKE since there's no wildcard
		# http://stackoverflow.com/questions/6142235/sql-like-vs-performance
		@search = Search.new(params[:track])
		if @search.valid?
			@tracks = Track.where("name LIKE ? AND artist_name LIKE ?", "#{params[:track][:track_name]}%", params[:track][:artist_name]).limit(20)
	  	@tracks_in_musicbrainz_and_not_db = @search.find_in_musicbrainz(@tracks.pluck(:mb_id))
		else
			render
		end
  end
end
