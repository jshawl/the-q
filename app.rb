require 'sinatra'
require 'sinatra/reloader'
require_relative './env.rb' if File.exists? 'env.rb'
require 'uri'
require 'net/http'
require 'cgi'

require_relative './pocket.rb'

enable :sessions
set :session_secret, ENV['q_session_secret']

get '/' do
  if session['access_token']
    @user = session['user']
    erb :home
  else
    erb :index
  end
end

get '/auth/pocket' do
  uri = URI.parse('https://getpocket.com/v3/oauth/request')
  response = Net::HTTP.post_form(uri, { 
    consumer_key: ENV['q_consumer_key'],
    redirect_uri: ENV['q_redirect_uri']
  })
  session['request_token'] = response.body.split("=")[1]
  redirect "https://getpocket.com/auth/authorize?request_token=#{session['request_token']}&redirect_uri=#{ENV['q_redirect_uri']}"
end

get '/auth/logout' do
  session['access_token'] = nil
  session['user'] = nil
  redirect ''
end

get '/callback' do
  uri = URI.parse('https://getpocket.com/v3/oauth/authorize')
  response = Net::HTTP.post_form(uri, { 
    consumer_key: ENV['q_consumer_key'],
    code: session['request_token']
  })
  data = CGI::parse( response.body )
  session['access_token'] = data['access_token']
  session['user'] = data['username'][0]
  redirect '/'
end
