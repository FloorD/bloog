require ’date’
require ’active_record’
class Post < ActiveRecord::Base
  include FigLeaf
  hide ActiveRecord::Base, ancestors: true,
         except: [Object, :init_with, :new_record?,
                  :errors, :valid?, :save]
    hide_singletons ActiveRecord::Calculations,
                    ActiveRecord::FinderMethods,
                    ActiveRecord::Relation
  validates :title, presence: true 
  attr_accessor :blog
  
  def picture?
    image_url.present? 
  end
  def publish(clock=DateTime) 
    return false unless valid? 
    self.pubdate = clock.now 
    @blog.add_entry(self)
  end 
  
  def initialize(attrs={})
    attrs.each do |k,v| send("#{k}=",v) end
  end
  
  def persisted? 
    false
  end
  
  def self.most_recent(limit=10)
    all(order: "pubdate DESC", limit: limit)
  end

  def save(*) 
    set_default_body super
  end

  private
  def set_default_body 
    if body.blank?
      self.body = ’Nothing to see here’ 
    end
end