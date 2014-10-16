class TagsController < ApplicationController
  def index
    @u = User.find_by( username: params[:user] )
    @tags = @u.tags.distinct
  end
  def show
    user = params[:user]
    tag = params[:tag]
    @u = User.find_by( username: params[:user] )
    @items = @u.items.joins(:tags).where( :tags => { :name => tag } )
  end
end
