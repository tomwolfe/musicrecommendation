class TracksController < ApplicationController
	skip_before_filter :authorize, only: [:show, :index]

	# GET /tracks/1
	# GET /tracks/1.json
	def show
		@track = Track.find(params[:id])

		if stale?(@track)
			respond_to do |format|
				format.html # show.html.erb
				format.json { render json: @track }
			end
		end
	end

	# POST /tracks
	# POST /tracks.json
	def create
		@track = Track.new(params[:track])

		respond_to do |format|
			if @track.save
				format.html { redirect_to @track, notice: "Track was successfully created." }
				format.json { render json: @track, status: :created, location: @track }
			else
				# TODO: sort of a bug, but I don't want users to be able to modify tracks directly
				# thus no #new action
				format.html { redirect_to root_path, flash: { alert: "Unable to create track." } }
				format.json { render json: @track.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		@track = Track.find(params[:id])
		if @track.update_attributes(params[:track])
			redirect_to home_signedin_path, notice: "Successfully updated track."
		else
			redirect_to home_signedin_path, flash: { alert: "Unable to update track." }
		end
	end
	
	# GET /tracks/index or GET /tracks/page/:page
	def index
		@page = params[:page] || "1"
		@tracks = Track.page(@page).order("average_rating DESC")
	end
	
	# GET /tracks/search
	def search
		# should still use index even w/ LIKE since there's no wildcard
		# http://stackoverflow.com/questions/6142235/sql-like-vs-performance
		@search = Search.new(params[:search])
		if @search.valid?
			@tracks = Track.where("name LIKE ? AND artist_name LIKE ?", "#{params[:search][:track_name]}%", "#{params[:search][:artist_name]}%").limit(20)
			@tracks_in_musicbrainz_and_not_db = @search.find_in_musicbrainz(@tracks.pluck(:mb_id))
		else
			redirect_to home_signedin_path(search: params[:search]), flash: { alert: "Invalid search parameters." }
		end
	end
end
