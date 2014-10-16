
class UsersController < ApplicationController
  def index
    if session['access_token']
      @user = session['user']
      uri = URI.parse('https://getpocket.com/v3/get')
      response = Net::HTTP.post_form(uri, { 
	consumer_key: ENV['q_consumer_key'],
	access_token: session['access_token'],
	detailType: 'complete'
      })
      @tags = User.find_by( username: @user ).tags.distinct
      render :home
    else
      render :index
    end
  end
  def login
    uri = URI.parse('https://getpocket.com/v3/oauth/request')
    response = Net::HTTP.post_form(uri, { 
      consumer_key: ENV['q_consumer_key'],
      redirect_uri: ENV['q_redirect_uri']
    })
    session['request_token'] = response.body.split("=")[1]

    redirect_to "https://getpocket.com/auth/authorize?request_token=#{session['request_token']}&redirect_uri=#{ENV['q_redirect_uri']}"
  end
  def new
    uri = URI.parse('https://getpocket.com/v3/oauth/authorize')
    response = Net::HTTP.post_form(uri, { 
      consumer_key: ENV['q_consumer_key'],
      code: session['request_token']
    })
    data = CGI::parse( response.body )
    session['access_token'] = data['access_token']
    session['user'] = data['username'][0]
    user = session['user']
    at = session['access_token'][0]
    @user = User.find_by( username: session['user'] ) || User.create_and_fetch( user, at )
    redirect_to '/'
  end
  def logout
    session['access_token'] = nil
    session['user'] = nil
    redirect_to ''
  end
end