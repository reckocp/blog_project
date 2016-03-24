class Comment
  attr_accessor :id, :message, :author
  def initialize(id, message, author, post_id)
    @id = id
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
