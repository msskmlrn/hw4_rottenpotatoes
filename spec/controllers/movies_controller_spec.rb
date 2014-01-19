require 'spec_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [mock('Movie'), mock('Movie')]
    end
    it 'should call the model method that performs TMDb search' do
      Movie.should_receive(:find_in_tmdb).with('hardware').
        and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'hardware'}
    end
    describe 'after valid search' do
      before :each do
        Movie.stub(:find_in_tmdb).and_return(@fake_results)
        post :search_tmdb, {:search_terms => 'hardware'}
      end
      it 'should select the Search Results template for rendering' do
        response.should render_template('search_tmdb')
      end
      it 'should make the TMDb search results available to that template' do
        assigns(:movies).should == @fake_results
      end
    end
  end
 
  describe "GET index" do
    describe "session full of old information" do
    	describe "sort in two ways" do
    		before :each do
        	@movie = Movie.create(:title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
        	session[:ratings] = {'R' => '1'}
      	end
	      it "sort by title" do
  	      session[:sort] = 'title'
  	      get :index, :sort => session[:sort], :ratings => session[:ratings]
  	      assigns(:movies).should == ([@movie])
      	end
				it "sort by date" do      
  	      session[:sort] = 'release_date'
  	      get :index, :sort => session[:sort], :ratings => session[:ratings]
  	      assigns(:movies).should == ([@movie])
  	    end
  	  end  
    end  
    describe "session is empty" do
    	before :each do
       	session[:sort] = "title"
        session[:ratings] = {"R" => "1"}
      end
      it "sort parameter missing" do
        get :index
        response.should redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
      end
      it "ratings paramenter missing" do
        get :index, :sort => session[:sort]
        response.should redirect_to(movies_path(:sort => session[:sort], :ratings => session[:ratings]))
      end   
    end
	end
	
	describe "POST create" do
   	before :each do
      MoviesController.stub(:create).and_return(mock('Movie'))
    	post :create, {:id => "1"}
    end
 		it "movie is assigned as @movie" do
      assigns(:movie).should be_a(Movie)
    end
    it "flash should be filled" do
    	flash[:notice].should_not be_blank
    end
    it "redirect to home page" do
    	response.should redirect_to(movies_path)
    end
  end
  
  describe "PUT update" do
    before :each do
    	@movie = mock(Movie, :title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
    	Movie.stub!(:find).with('1').and_return(@movie)
    	@movie.stub!(:update_attributes!).and_return(true)
        put :update, {:id => '1', :movie => @movie}
    end  
    it "updates the requested movie" do
      assigns(:movie).should eq(@movie)
    end
    it "flash should be filled" do
    	flash[:notice].should_not be_blank
    end
		it "redirects to home page" do 
     	response.should redirect_to(movie_path(@movie))
    end
  end
  
  describe "GET edit" do
    it "movie is assigned as @movie" do
      @movie = mock(Movie, :title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
      Movie.stub!(:find).with('1').and_return(@movie)
      get :edit, :id => @movie.id
      assigns(:movie).should eq(@movie)
    end
  end
  
  describe "GET show" do
    it "movie is assigned as @movie" do
      @movie = mock(Movie, :title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
      Movie.stub!(:find).with('1').and_return(@movie)
      get :show, :id => @movie.id
      assigns(:movie).should eq(@movie)
    end
  end
  
  describe "DELETE destroy" do
  	before :each do
    	@movie = mock(Movie, :title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
    	Movie.stub!(:find).with('1').and_return(@movie)
    	@movie.should_receive(:destroy)
    	delete :destroy, {:id => '1'}
    end  
    it "destroy movie" do
    end
 		it "flash should be filled" do
    	flash[:notice].should_not be_blank
    end
		it "redirects to home page" do 
     	response.should redirect_to(movies_path)
    end
  end
  
  describe "GET same_director" do
    describe "with director" do
      it "assigns all movies as @movies" do
        @movie = Movie.create(:title => 'Iron Sky', :rating => 'R', :director => 'Timo Vuorensola', :id => '1')
        get :same_director, :id => @movie.id
        assigns(:movies).should == ([@movie])
      end
    end
    describe "without director" do
    	before :each do
    		@movie = Movie.create(:title => 'Iron Sky', :rating => 'R', :id => '1')
      	get :same_director, :id => @movie.id
    	end  
    	it "flash should be filled" do
    		flash[:notice].should_not be_blank
    	end
    	it "redirect to home page" do
      	response.should redirect_to(movies_path)
      end
    end
  end  
end
