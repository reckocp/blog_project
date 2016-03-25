class PostsController < ApplicationController
  def index
    @posts = App.posts
    render_template 'posts/index.html.erb'
  end

  def show
    post = find_post_by_id

    if post
      @post = post
      @comments = App.comments.select { |comment| comment.post_id == post.id }
      render_template 'posts/show.html.erb'
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
      Post.new(new_id, params[:title], params[:author], params[:body], true)
    )
    redirect_to "/posts"

  end

  def edit
    @post = find_post_by_id

    render_template "posts/edit.html.erb"
  end

  def update
    post = find_post_by_id
    if post
      unless params[:title].nil? || params[:title].empty?
        post.title = params[:title]
      end

      unless params[:author].nil? || params[:author].empty?
        post.author = params[:author]
      end

      unless params[:body].nil? || params[:body].empty?
        post.body = params[:body]
      end

      redirect_to "/posts"
    else
      render_not_found
    end
  end

  def destroy
    post = find_post_by_id

    if post
      App.posts.delete(post)
      redirect_to "/posts"
    else
      render_not_found
    end
  end

  private

  def find_post_by_id
    App.posts.find { |p| p.id == params[:id].to_i }
  end

  def render_not_found
    render_template "posts/notfound.html.erb"
  end
end
