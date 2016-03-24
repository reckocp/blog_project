class PostsController < ApplicationController
  def index
    if request[:format] == "json"
      render App.posts.to_json, status: "200 OK"
    else
      @posts = App.posts
      render_template 'posts/index.html.erb'
    end
  end

  def show
    post = find_post_by_id

    if post
      if request[:format] == "json"
        render post.to_json
      else
        @post = post
        render_template 'posts/show.html.erb'
      end
    else
      render_not_found
    end
  end

  def new
    render_template 'posts/new.html.erb'
  end

  def create
    last_post = App.posts.max_by { |post| post.id }
    new_id = last_post.id + 1

    App.posts.push(
      Post.new(new_id, params["title"], params["author"], params["body"], true)
    )
    puts App.posts.to_json

    render({ message: "Successfully created!", id: new_id }.to_json)
  end

  def update
    post = find_post_by_id
    if post
      unless params["title"].nil? || params["title"].empty?
        post.title = params["title"]
      end

      unless params["author"].nil? || params["author"].empty?
        post.author = params["author"]
      end

      unless params["body"].nil? || params["body"].empty?
        post.body = params["body"]
      end

      render post.to_json, status: "200 OK"
    else
      render_not_found
    end
  end

  def destroy
    post = find_post_by_id

    if post
      App.posts.delete(post)
      render({ message: "Successfully Deleted Post" }.to_json)
    else
      render_not_found
    end
  end

  private

  def find_post_by_id
    App.posts.find { |p| p.id == params[:id].to_i }
  end

  def render_not_found
    return_message = {
      message: "Post not found!",
      status: '404'
    }.to_json

    render return_message, status: "404 NOT FOUND"
  end
end
