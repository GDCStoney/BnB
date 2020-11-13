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
    session[:filter_listing] ? @my_listings = session[:user].id : @my_listings = nil
    @listings = Listing.all(field: session[:field], search: session[:search], host_id: @my_listings)
    erb :homepage
  end

  post '/' do
    # determine if username/password is correct
    @user = User.sign_in(username: params[:username], password: params[:password])
    session[:user] = @user
    redirect '/' # with session variable of username/ID
  end

  post '/my_listings' do
    session[:filter_listing] ? session[:filter_listing] = nil : session[:filter_listing] = params[:filter_listing]
    redirect '/'
  end

  get '/clear/' do
    session.clear
  end

  post '/search' do
    session[:field] = params[:field]
    session[:search] = params[:search]
    redirect '/'
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

  get '/listing/add' do
    erb :add_listing
  end

  post '/listing/add' do
    if params[:image] && params[:image][:filename]
      filename = params[:image][:filename]
      file = params[:image][:tempfile]
      path = "./public/uploads/#{filename}"

      File.open(path, 'wb+') do |f|
        f.write(file.read)
      end
    end
    result = Listing.create(name: params[:name], description: params[:description], host_id: session[:user].id, price: params[:price], start_date: params[:start_date], end_date: params[:end_date], image_filename: path.gsub('./public',''))
    redirect '/'
  end

  get '/listing/edit' do
    @listing = Listing.find(id: params[:id])
    erb :listing_edit
  end

  post '/listing/edit' do
    description_for_query = params[:description].gsub("'", "''")
    name_for_query = params[:name].gsub("'", "''")
    if params[:image] && params[:image][:filename]
      filename = params[:image][:filename]
      file = params[:image][:tempfile]
      path = "./public/uploads/#{filename}"

      File.open(path, 'wb+') do |f|
        f.write(file.read)
      end
    end
    @listing = Listing.update(name: name_for_query, description: description_for_query, price: params[:price], start_date: params[:start_date], end_date: params[:end_date], id: params[:id], image_filename: path.gsub('./public',''))
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
    booking = Booking.create(listing_id: listing.id, user_id: user.id, start_date: params[:start_date], end_date: params[:end_date], price: listing.price, confirmation: false)
    Booking.text_confirmation(username: user.username, listing_name: listing.name, start_date: params[:start_date], end_date: params[:end_date], price_total: booking.price_total)
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
