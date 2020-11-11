require 'sinatra'
require 'sinatra/flash'
require 'pg'
require_relative './lib/user'
require_relative './lib/listing'
require './lib/database_connection_setup'

class BnB < Sinatra::Base
  register Sinatra::Flash
  enable :sessions
  set :session_secret, 'here be turtles'

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

  get '/listing/edit' do
    @listing = Listing.find(id: params[:id])
    erb :listing_edit
  end

  post '/listing/edit' do
    @listing = Listing.update(name: params[:name], description: params[:description], price: params[:price], start_date: params[:start_date], end_date: params[:end_date], id: params[:id])
    redirect '/'
  end

  get '/calendar/trial' do
    erb :calendar_trial
  end
  get '/calendar/simple' do
    erb :calendar_simple
  end
  get '/calendar/html' do
    erb :calendar_html
  end
end
