class APICommentsController < ApplicationController
  def index
    render App.comments.to_json, status: "200 OK"
  end

  def show
    comment = find_comment_by_id

    if comment
      render comment.to_json
    else
      render_not_found
    end
  end

  def create
    last_comment = App.comments.max_by { |comment| comment.comment_id }
    new_id = last_comment.comment_id + 1

    App.comments.push(
      comment.new(new_id, params["message"], params["author"], params["post_id"])
    )
    render({ message: "Successfully created!", id: new_id }.to_json)
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

      render comment.to_json, status: "200 OK"
    else
      render_not_found
    end
  end

  def destroy
    comment = find_comment_by_id

    if comment
      render({ message: "Successfully Deleted Comment" }.to_json)
    else
      render_not_found
    end
  end

  private
  def find_comment_by_id
    App.comments.find { |c| c.comment_id == params[:id].to_i }
  end

  def render_not_found
    return_message = {
      message: "Comment not found!",
      status: '404'
    }.to_json

    render return_message, status: "404 NOT FOUND"
  end
end
