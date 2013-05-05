require 'date'
require 'active_record'
class Post < ActiveRecord::Base 
  hide ActiveRecord::Base, ancestors: true,
         except: [Object, :init_with, :new_record?,
                  :errors, :valid?, :save]
    hide_singletons ActiveRecord::Calculations,
                    ActiveRecord::FinderMethods,
                    ActiveRecord::Relation
  validates :title, presence: true 
  attr_accessor :blog
  composed_of :tags, class_name: ’TagList’, mapping: %w(tags tags),
                     converter: ->(value) { TagList(value) }
  serialize :tags
  
  def picture?
    image_url.present? 
  end
  
  def publish(clock=DateTime) 
    return false unless valid? 
    self.pubdate = clock.now 
    @blog.add_entry(self)
  end 
  
  def self.first_before(date) 
    first(conditions: ["pubdate < ?", date],
          order:      "pubdate DESC")
  end
  
  def self.first_after(date)
    first(conditions: ["pubdate > ?", date],
          order:      "pubdate ASC")
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

  def prev 
    self.class.first_before(pubdate)
  end
  
  def next 
    self.class.first_after(pubdate)
  end
  
  def up 
    blog
  end

  def self.most_recent(limit=LIMIT_DEFAULT)
    order("pubdate DESC").limit(limit) 
  end
  
  def self.all_tags_alphabetical 
    all_tags.alphabetical
  end
  
  def self.all_tags 
    except(:limit).map(&:tags).reduce(TagList.new([]), &:+)
  end

  private
  def set_default_body 
    if body.blank?
      self.body = 'Nothing to see here' 
    end
  end
end