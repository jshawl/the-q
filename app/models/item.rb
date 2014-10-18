class Item < ActiveRecord::Base
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
  def self.create_from_json item, user
      if item['given_title'].blank?
	title = item['resolved_title']
      else
	title = item['given_title']
      end
      begin
	@item = Item.find_by( pocket_id: item['item_id'] )
	if @item == nil
	  @item = user.items.create( pocket_id: item['item_id'], title: title, url: item['resolved_url'] )
	end
      rescue
	@item = Item.new # avoid truncation column error
      end
      if item['tags']
	@item.tags.destroy_all
	tags = item['tags'].map{ |name, con| name }
	tags.each do |tag|
	  @tag = user.tags.find_or_create_by( name: tag )
	  @tag.user = user
	  @tag.save
	  if @item
	    @item.tags.find_or_create_by( name: tag )
	  end
	end
      end
  end
end