require "roda"

class App < Roda
  plugin :json_parser

  def is_authorized?(api_key)
    !api_key.nil? && !api_key.empty? && ENV["API_KEY"] == api_key
  end

  route do |r|
    r.root do
      "Welcome to the Jungle"
    end

    r.is "create_post", method: [:post, :put] do
      if is_authorized?(request.params.delete("api_key"))
        cp = CreatePost.new(request.params)
        response.status = cp.status
        cp.message
      else
        response.status = 409
        "Invalid API Key"
      end
    end
  end
end
