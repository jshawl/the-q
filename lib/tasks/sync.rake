namespace :users do
  desc "get pocket things"
  task :sync => :environment do
    puts User.all
    users = User.all
    users.each do |user|
      uri = URI.parse('https://getpocket.com/v3/get')
      since = user.items.order("updated_at").last.updated_at
      response = Net::HTTP.post_form(uri, { 
	consumer_key: ENV['q_consumer_key'],
	access_token: user.access_token,
	detailType: 'complete',
	state: 'all',
	since: since.to_i
      })
      data = JSON.parse( response.body )['list']
      items = data.map{ |pocket_id, item| item }

      items.each do |item|
	if item['status'] == "2"
	  item = Item.find_by( pocket_id: item['item_id'] )
	  item && item.destroy
	else
          Item.create_from_json item, user
	end
      end
    end
  end

  desc "remove empty tags"
  task :clean => :environment do
    users = User.all
    users.each do |user|
      tags = user.tags 
      tags.each do |tag|
	items = user.items.joins(:tags).where( :tags => { :name => tag.name } )
        if items.length == 0	
	  tag.destroy
	end
      end
    end
  end
  
end