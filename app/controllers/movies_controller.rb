class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #PART 3 HW2
    if session[:params].nil?
      session[:params] = params
    end
    if params[:sort_by].nil? and params[:ratings].nil? and
      ( session[:params][:sort_by] or session[:params][:ratings])
      flash.keep
      redirect_to movies_path( session[:params] )
    else 
      session[:params] = params
    end
    #PART 2 HW2
    @all_ratings = Movie.all.map(&:rating).uniq
    if session[:selected_ratings].nil?
      session[:selected_ratings] = @all_ratings
    end
    if params[:ratings]
      session[:selected_ratings] = params[:ratings].keys
    end
    @selected_ratings = session[:selected_ratings]
    #PART 1 HW1
    if( params[:sort] )
      @movies = Movie.where(rating: @selected_ratings).order(params[:sort_by] + " ASC")
      @hilite = params[:sort_by] 
    else
      @movies = Movie.where(rating: @selected_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
