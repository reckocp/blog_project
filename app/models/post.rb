class Post
  attr_accessor id:, :title, :author, :body, :published
  def initialize(id, title, author, body, published)
    @id = id
    @title = title
    @author = author
    @body = body
    @published = published
  end

  def to_json(_ = nil)
  {
    id: id,
    title: body,
    author: author,
    body: body
  }.to_json
  end

  def published?
    @published == true
  end 
end
