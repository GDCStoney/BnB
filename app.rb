require 'Sinatra'
require 'pg'
require_relative './lib/user'
require './lib/database_connection_setup'

class BnB < Sinatra::Base
  enable :sessions
  set :session_secret, 'here be turtles'

  get '/' do
    # use session[:username] to determine view conent
    @user = session['user']
    erb :homepage
  end

  post '/' do
    # determine if username/password is correct
    user_id = User.sign_in(username: params[:username], password: params[:password])
    p user_id.inspect
    session[:user] = User.find(id: user_id)
    redirect '/' # with session variable of username/ID
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/sign_up' do
    @new_user = User.sign_up(username: params[:username], password: params[:password], phone_no: params[:phone], email: params[:email])
    if !@new_user
      sinatra::flash 'Username taken, please try again'
      redirect '/sign_up'
    else
      session[:user] = @new_user
    end

    redirect '/'
  end
end
