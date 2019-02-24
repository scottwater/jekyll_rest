require_relative "../spec_helper"

describe CreatePost do
  describe "Common Use Case with Defaults" do
    before(:all) do
      ENV["GITHUB_USER"] = "scottwater"
      ENV["GITHUB_REPO"] = "not_my_blog"
    end

    it "will create a new post" do
      stub_request(:put, "https://api.github.com/repos/scottwater/not_my_blog/contents/_posts/#{Date.today}-hello-world.md").to_return(status: 201)
      cp = CreatePost.new("body" => "Hello World", "title" => "Hello World")
      expect(cp.status).to eql(201)
    end
  end

  describe "Overrides" do
    it "will create a new post" do
      stub_request(:put, "https://api.github.com/repos/bob/blog/contents/shorts/_posts/#{Date.today}-hello-world.md").to_return(status: 201)
      cp = CreatePost.new("body" => "Hello World", "title" => "Hello World", "user" => "bob", "repo" => "blog", "directory" => "shorts")
      expect(cp.status).to eql(201)
    end
  end
end
