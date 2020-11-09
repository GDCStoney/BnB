require 'Sinatra'
require 'pg'

class BnB < Sinatra::Base
  enable :sessions
  set :session_secret, 'here be turtles'

  get '/' do
    # use session[:username] to determine view conent
    @username = session['username']
    erb :homepage
  end

  post '/' do
    # determine if username/password is correct
    session[:username] = params[:username]
    redirect '/' # with session variable of username/ID
  end

  get '/sign_up' do

  end

  get '/test' do
    @username = session['username']
    erb :homepage
  end
end
