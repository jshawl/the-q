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
      detailType: 'complete'
    })
    data = JSON.parse( response.body )['list']
    data.each do |pocket_id, item|
      if item['given_title'].blank?
	title = item['resolved_title']
      else
	title = item['given_title']
      end
      @item = @user.items.create( pocket_id: pocket_id, title: title, url: item['resolved_url'] )
      @item.save
      if item['tags']
	tags = item['tags'].map{ |name, con| name }
	tags.each do |tag|
	  @tag = @user.tags.find_or_create_by( name: tag )
	  @tag.user = @user
	  @tag.save
	  @item.tags.find_or_create_by( name: tag )
	end
      end
    end
  end
end