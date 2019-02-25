require "http"
require "json"

class CreatePost
  attr_reader :response, :status

  def initialize(params)
    directory = params.delete("directory") || ENV["BLOG_DIRECTORY"]
    repo = params.delete("repo") || ENV["GITHUB_REPO"]
    branch = params.delete("branch") || ENV["GITHUB_BRANCH"] || "master"
    user = params.delete("user") || ENV["GITHUB_USER"]

    if valid?(user, repo)
      r2p = RequestToPost.new(params)

      data = {
        branch: branch || ENV["BRANCH"] || "master",
        content: r2p.content_encoded,
        message: "New Post: #{r2p.properties["title"]}",
      }

      request_path = generate_request_path(user, repo, directory, r2p.file_path)
      @response = send_to_github(request_path, data)
    end
  end

  def message
    case status
    when 201 then "Post Created"
    when 401 then "Invalid Github Credentials"
    when 409 then "Missing User or Repo"
    when 422 then "Duplicate Post. New Post Failed"
    else
      "Unkown Result for #{status}"
    end
  end

  private

  def valid?(user, repo)
    (user && repo).tap do |valid|
      unless valid
        @status = 409
      end
    end
  end

  def generate_request_path(user, repo, directory, post_path)
    "https://api.github.com/repos/#{user}/#{repo}/contents/#{generate_post_path(directory, post_path)}"
  end

  def generate_post_path(directory, post_path)
    if directory
      "#{directory}/#{post_path}"
    else
      post_path
    end
  end

  def send_to_github(request_path, data)
    HTTP
      .headers({
        "Authorization" => "token #{ENV["GITHUB_API_KEY"]}",
        "Accept" => "application/vnd.github.v3+json",
        "User-Agent" => "Jekyll Rest",
      })
      .put(request_path, body: data.to_json)
      .tap do |resp|
        @status = resp.status
    end
  end
end
