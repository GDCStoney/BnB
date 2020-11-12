require 'sinatra'
require 'sinatra/flash'
require 'pg'
require_relative './lib/user'
require_relative './lib/listing'
require './lib/database_connection_setup'
require 'date'
require_relative './lib/booking'

class BnB < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, 'here be turtles'

  get '/' do
    # use session[:username] to determine view conent
    @user = session[:user]
    @listings = Listing.all(field: session[:field], search: session[:search])
    erb :homepage
  end

  post '/' do
    # determine if username/password is correct
    @user = User.sign_in(username: params[:username], password: params[:password])
    session[:user] = @user
    redirect '/' # with session variable of username/ID
  end
  get '/clear/' do
    session.clear
  end
  post '/search' do
    session[:field] = params[:field]
    session[:search] = params[:search]
    redirect '/'
  end

  get '/listing/add' do
    erb :add_listing
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/sign_up' do
    @new_user = User.sign_up(username: params[:username], password: params[:password], phone_no: params[:phone], email: params[:email])
    if !@new_user
      flash[:notice] = 'Username taken, please try again'
      redirect '/sign_up'
    else
      session[:user] = @new_user
    end
    redirect '/'
  end

  get '/listing/edit' do
    @listing = Listing.find(id: params[:id])
    erb :listing_edit
  end

  post '/listing/edit' do
    description_for_query = params[:description].gsub("'", "''")
    @listing = Listing.update(name: params[:name], description: description_for_query, price: params[:price], start_date: params[:start_date], end_date: params[:end_date], id: params[:id])
    redirect '/'
  end

  get '/listing/delete' do
    @listing = Listing.find(id: params[:id])
    erb :listing_delete_confirmation
  end

  post '/listing/delete' do
    @listing = Listing.delete(id: params[:id])
    redirect '/'
  end

  get '/listing/:id' do
    @taken_dates = Booking.get_unavailable_dates(listing_id: params[:id]).to_s.gsub('"',"")
    @listing = Listing.find(id: params[:id])
    # Hard coded @listing for testing:
    # @listing = Listing.create(name: "Test listing", price: 40.00, description: "This is a very nice house.", host_id: 1, start_date: "2020-12-25", end_date: "2020-12-30")
    erb :listing_view
  end

  get '/booking/edit/:id' do
    @booking = Booking.find(id: params[:id])
    erb :booking_edit
  end

  post '/booking/edit/:id' do
    Booking.update(id: params[:id], start_date: params[:start_date], end_date: params[:end_date])
    redirect '/'
  end

  get '/booking/delete/:id' do
    @booking = Booking.find(id: params[:id])
    erb :booking_delete_confirmation
  end

  post '/booking/delete/:id' do
    Booking.delete(id: params[:id])
    redirect '/'
  end

  post '/booking/manager/:id' do
    user = session[:user]
    listing = Listing.find(id: params[:id])
    Booking.create(listing_id: listing.id, user_id: user.id, start_date: params[:start_date], end_date: params[:end_date], price: listing.price, confirmation: false)
    redirect '/booking/manager'
  end

  get '/booking/manager' do
    @user = session[:user]
    @bookings = Booking.get_user_bookings(user_id: @user.id)
    @listings = []
    @bookings.each do |booking|
      @listings << Listing.find(id: booking.listing_id)
    end
    erb :booking_manager
  end
end
