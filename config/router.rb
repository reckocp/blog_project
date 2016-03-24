class Router
  def initialize(request)
    @request = request
  end

  def route
    [
      api_resource('api/posts', APIPostsController),
      api_resource('api/comments', APICommentsController),
      resource("posts", PostsController),
      resource("comments", CommentsController),

      get('/assets/:type/:name', AssetsController, :handle)
    ].flatten.find(&:itself)
  end

  private # No need to edit these, but feel free to read them to see how they work

  def api_resource(name, controller)
    [
      post("/#{name}",       controller, :create),
      delete("/#{name}/:id", controller, :destroy),
      put("/#{name}/:id",    controller, :update),
      get("/#{name}/:id",    controller, :show),
      get("/#{name}",        controller, :index),
    ]
  end

  def resource(name, controller)
    [
      post("/#{name}",            controller, :create),
      post("/#{name}/:id/delete", controller, :destroy), #will be DELETE in rails
      post("/#{name}/:id",        controller, :update), #will be PUT in Rails

      get("/#{name}/:id/edit",    controller, :edit),
      get("/#{name}/new",         controller, :new),
      get("/#{name}/:id",         controller, :show),
      get("/#{name}",             controller, :index),
    ]
  end

  def get(url_str, resource, action)
    if get? && route_match?(url_str)
      fill_params(url_str)
      send_to_controller(resource, action)
    end
  end

  def post(url_str, resource, action)
    if post? && route_match?(url_str)
      fill_params(url_str)
      send_to_controller(resource, action)
    end
  end

  def put(url_str, resource, action)
    if put? && route_match?(url_str)
      fill_params(url_str)
      send_to_controller(resource, action)
    end
  end

  def delete(url_str, resource, action)
    if delete? && route_match?(url_str)
      fill_params(url_str)
      send_to_controller(resource, action)
    end
  end

  def get?
    @request[:method] == "GET"
  end

  def put?
    @request[:method] == "PUT"
  end

  def post?
    @request[:method] == "POST"
  end

  def delete?
    @request[:method] == "DELETE"
  end

  def fill_params(url)
    params = Hash[url[1..-1]
              .split('/')
              .zip(@request[:paths])
              .select { |key, value| key[0] == ":" }
              .map { |key, value| [key[1..-1].to_sym, value] }]
    @request[:params].merge!(params)
  end

  def send_to_controller(resource, action)
    @request[:params].merge!({
      controller_name: resource.to_s,
      action_name: action
    })
    resource.new(@request).send(action)
  end

  def route_match?(url)
    @request[:route] =~ Regexp.new("^#{con(url)}$")
  end

  def con(str)
    return str unless str.include?(':')
    updated_str = str.gsub(/(?:(?::.+[\/]([^:]+))|(:.+(.+)$))/) do
      first_match = Regexp.last_match[1]
      if first_match.nil?
        "(.+)"
      else
        "(.+)/#{first_match}"
      end
    end
    con(updated_str)
  end
end
