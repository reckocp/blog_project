class Comment
  attr_accessor :comment_id, :message, :author
  def initialize(comment_id, message, author, post_id)
    @comment_id = comment_id
    @message = message
    @author = author
    @post_id = post_id
  end

  def to_json(_ = nil)
    {
      id: id,
      message: message,
      author: author
    }.to_json
  end

  def link_ids
    @post_id = @id
  end
end
