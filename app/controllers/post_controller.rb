class PostsController
  respond_to :html, :json
  include ExhibitsHelper
  
  def create
    @post = @blog.new_post(params[:post]) 
    if @post.publish
      redirect_to root_path, notice: "Post added!" 
    else
    render "new" 
  end
  
  def show
    @post = exhibit(Post.find_by_id(params[:id]), self) 
    respond_with(@post)
  end
end