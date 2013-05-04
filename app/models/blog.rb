class Blog
  attr_writer :post_source, :title, :subtitle, :body

  def initialize(entry_fetcher=Post.public_method(:all)) 
    @entry_fetcher = entry_fetcher
  end
  
  before do
   @entries = []
   @it = Blog.new(->{@entries})
  end
  
  def new_post(*args) 
    post_source.call(*args).tap do |p|
      p.blog = self
    end
  end
  
  def initialize(entry_fetcher=Post.public_method(:most_recent)) 
    @entry_fetcher = entry_fetcher
  end
  
  def add_entry(entry) 
    entry.save
  end
  
  private

  def fetch_entries 
    @entry_fetcher.()
  end
  
  def post_source
    @post_source ||= Post.public_method(:new) 
  end
end