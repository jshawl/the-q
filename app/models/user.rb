class User < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :items

  def self.create_and_fetch user, at
    @user = User.create( username: user, access_token: at ) 
    uri = URI.parse('https://getpocket.com/v3/get')
    response = Net::HTTP.post_form(uri, { 
      consumer_key: ENV['q_consumer_key'],
      access_token: @user.access_token,
      detailType: 'complete',
      state: 'all'
    })
    data = JSON.parse( response.body )['list']
    data.each do |pocket_id, item|
      @item = Item.create_from_json item, @user
    end
  end
end