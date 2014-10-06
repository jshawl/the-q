require 'httparty'
require_relative './env.rb'

class Pocket

  attr_reader :access_token

  def initialize access_token
    @access_token = access_token
  end

  def tags
    url = "https://getpocket.com/v3/get?access_token=#{@access_token}&consumer_key=#{ENV['q_consumer_key']}&detailType=complete&state=all"
    res = HTTParty.get( url )
    @tags = []
    items = res['list']
    items.each do |num, val|
      if val['tags']
        val['tags'].each do |tag, ex| 
	  @tags << tag
	end
      end
    end
    puts @tags.uniq
  end

end
