class TagsController < ApplicationController
  def index
    @u = User.find_by( username: params[:user] )
    @tags = @u.tags
  end
  def show
    user = params[:user]
    tag = params[:tag]
    @u = User.find_by( username: params[:user] )
    @tag = @u.tags.find_by( name: tag )
    @current_user = User.find_by( username: session['user'] )
    if @tag.public || @current_user && @current_user.id == @tag.user_id
      @items = @u.items.joins(:tags).where( :tags => { :name => tag } )
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
  def update
    @tag = Tag.find( params[:id] )
    @tag.update tag_params
    username = User.find( params[:user_id] ).username
    redirect_to '/' + username + '/' + @tag.name
  end

  private
  def tag_params
    params.require(:tag).permit(:public)
  end
end
