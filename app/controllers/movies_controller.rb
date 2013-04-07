class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    needs_redirect = true

    if params[:order] != session[:order] && params[:ratings] != session[:order]
      needs_redirect = false
    end

    if params[:order]
      session[:order] = params[:order]
    end

    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if session[:order] == "title"
        @title_class = "hilite"
    elsif session[:order] == "release_date"
        @date_class = "hilite"
    end

    if session[:ratings]
      if session[:ratings].kind_of?(Array)
        session[:ratings] = session[:ratings]
      else
        session[:ratings] = session[:ratings].keys
      end
    else
      session[:ratings] = @all_ratings
    end

    @movies = Movie.find(:all, :conditions => ['rating IN (?)', session[:ratings]], :order => session[:order])

    if needs_redirect
      flash.keep
      redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
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
