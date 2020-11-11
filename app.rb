require 'sinatra'
require 'sinatra/flash'
require 'pg'
require 'calendar_helper'
require_relative './lib/user'
require_relative './lib/listing'
require './lib/database_connection_setup'
require 'date'

class BnB < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, 'here be turtles'

  helpers do
    include CalendarHelper
  end

  get '/' do
    # use session[:username] to determine view conent
    @user = session[:user]
    @listings = Listing.all
    erb :homepage
  end

  post '/' do
    # determine if username/password is correct
    @user = User.sign_in(username: params[:username], password: params[:password])
    session[:user] = @user
    redirect '/' # with session variable of username/ID
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

  get '/listing/:id' do
    @taken_dates = []
    bookings = Listing.get_bookings(id: params[:id])
    bookings.each do |booking|
      @taken_dates << [booking.start_date, booking.end_date]
    end
    @listing = Listing.find(params[:id])
    # Hard coded @listing for testing:
    # @listing = Listing.create(name: "Test listing", price: 40.00, description: "This is a very nice house.", host_id: 1, start_date: "2020-12-25", end_date: "2020-12-30")
    erb :listing_view
  end
 
end
