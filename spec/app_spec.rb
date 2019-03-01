require_relative "spec_helper"

describe App do

  def app
    App.freeze.app
  end

  it "returns something on root" do
    get "/"
    expect(last_response.body).to eql("Welcome to the Jungle")
  end

  let(:data) {{body: "Hello World", title: "A Title", api_key: "1234", user: "bob", repo: "blog"}}

  describe "with data" do

    before do
      ENV["API_KEY"] = "1234"
      ENV["GITHUB_TOKEN"] = "1234"
      stub_request(:put, "https://api.github.com/repos/bob/blog/contents/_posts/#{Date.today}-title.md").to_return(status: 201)
    end


    it "accepts json" do 
      header "Content-Type", "application/json"
      put "/create_post", data.to_json
      expect(last_response.status).to eql(201)
    end

    it "A form post" do 
      put "/create_post", data
      expect(last_response.status).to eql(201)
    end
  end

  describe "Invalid credentials" do

    it "has no API Key configured" do 
      ENV["API_KEY"] = nil
      put "/create_post", data
      expect(last_response.status).to eql(409)
    end

    it "even if the keys are nil it is a 409" do 
      ENV["API_KEY"] = nil
      data.delete(:api_key)
      put "/create_post", data
      expect(last_response.status).to eql(409)
    end

    it "even if the required API is empty and matches it is a 409" do 
      ENV["API_KEY"] = ""
      data[:api_key] = ""
      put "/create_post", data
      expect(last_response.status).to eql(409)
    end

  end
end
