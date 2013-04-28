require ’delegate’
class LinkExhibit < Exhibit
  def self.applicable_to?(object) 
    object.is_a?(Post)
￼ end