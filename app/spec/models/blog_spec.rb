require ’minitest/autorun’ 
require_relative ’../../app/models/blog’ 
require ’ostruct’

describe Blog do
  
  before do
      @it = Blog.new
    end
  
  describe "#new_post" do 
    before do
        @new_post = OpenStruct.new
        @it.post_source = ->{ @new_post } 
      end
  
  describe "#add_entry" do
    it "adds the entry to the blog" do 
      entry = Object.new 
      @it.add_entry(entry) 
      @it.entries.must_include(entry)
      end 
    end
    
  describe "#pubdate" do
    describe "before publishing" do
      it "is blank" do 
        @it.pubdate.must_be_nil
      end 
    end
    
    describe "after publishing" do 
      before do
        @clock = stub!
        @now = DateTime.parse("2011-09-11T02:56")
        stub(@clock).now(){@now}
        @it.blog = stub!
        @it.publish(@clock)
      end
    end
  end
  
  it "is the current time" do 
    @it.pubdate.must_equal(@now)
  end
  
  it "sets the post’s blog reference to itself" do
    @it.new_post.blog.must_equal(@it) 
  end

  it "has no entries" do
    @it.entries.must_be_empty 
  end
  
  it "accepts an attribute hash on behalf of the post maker" do 
    post_source = MiniTest::Mock.new
    post_source.expect(:call, @new_post, [{x: 42, y: ’z’}])
    @it.post_source = post_source
    @it.new_post(x: 42, y: ’z’)
    post_source.verify 
  end
end

# subject { Blog.new(->{entries}) } 
# let(:entries) { [] }
# it "has no entries" do 
#  subject.entries.must_be_empty
# end