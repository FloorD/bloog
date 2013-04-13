class Blog
  attr_writer :post_source, :title, :subtitle, :body

  def initialize 
    @entries = []
  end
  
  def new_post(*args) 
    post_source.call(*args).tap do |p|
      p.blog = self
    end
  end
  
  def add_entry(entry) 
    entries << entry
  end
  
  def entries
    @entries.sort_by{|e| e.pubdate}.reverse.take(10) 
  end
  
  private
  def post_source
    @post_source ||= Post.public_method(:new) 
  end
end