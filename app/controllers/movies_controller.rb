class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    if session[:ratings] || session[:order]
      needs_redirect = true
    end

    if params[:order]
      session[:order] = params[:order]
    end

    if params[:ratings] == []
      session[:ratings] = session[:ratings]
    elsif params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if session[:order] == "title"
        @title_class = "hilite"
    elsif session[:order] == "release_date"
        @date_class = "hilite"
    end

    if session[:order]
      @order = session[:order]
    end

    if session[:ratings]
      ratings = session[:ratings]
      if ratings.kind_of?(Array)
        @ratings = ratings
      else
        @ratings = ratings.keys
      end
    else
      @ratings = @all_ratings
    end

    session[:ratings] = @ratings

    @movies = Movie.find(:all, :conditions => ['rating IN (?)', session[:ratings]], :order => session[:order])

    if needs_redirect
      flash.keep
      session.clear
      redirect_to movies_path(:ratings => @ratings, :order => @order)
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
