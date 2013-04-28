require ’delegate’
class TextPostExhibit < Exhibit
  def self.applicable_to?(object)
    object.is_a?(Post) && (!object.picture?) 
  end
  
  def initialize(model, context) 
    @context = context 
    super(model)
  end

  def render_body
      @context.render(partial: "/posts/text_body", locals: {post: self})
  end 
end