class CommentsController < ApplicationController
  def index
    @comments = App.comments
    render_template 'comments/index.html.erb'
  end

  def show
    comment = find_comment_by_id

    if comment
      @comment = comment
      render_template 'comments/show.html.erb'
    else
      render_not_found
    end
  end

  def new
    render_template 'comments/new.html.erb'
  end

  def create
    last_comment = App.comments.max_by { |comment| comment.comment_id }
    new_id = last_comment.comment_id + 1

    App.comments.push(
      Comment.new(new_id, params[:message], params[:author], params[:post_id])
    )
    redirect_to "/comments"
  end

  def update
    comment = find_comment_by_id
    if comment
      unless params["message"].nil? || params["message"].empty?
        comment.message = params["message"]
      end

      unless params["author"].nil? || params["author"].empty?
        comment.author = params["author"]
      end

      unless params["post_id"].nil? || params["post_id"].empty?
        comment.post_id = params["post_id"]
      end

      redirect_to "comments/show.html.erb"
    else
      render_not_found
    end
  end

  def destroy
    comment = find_comment_by_id

    if comment
      App.comments.delete(comment)
      redirect_to "/comments"
    else
      render_not_found
    end
  end

  private

  def find_comment_by_id
    App.comments.find { |c| c.comment_id == params[:id].to_i }
  end

  def render_not_found
    render_template "comments/notfound.html.erb"

  end
end
