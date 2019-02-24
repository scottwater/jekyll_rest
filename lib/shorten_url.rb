require "http"

module ShortenUrl
  def self.create(url)
    if ENV["SHORTI_URL"] && ENV["SHORTI_API_KEY"]
      rsp = HTTP.post(ENV["SHORTI_URL"], form: {url: url, api_key: ENV["SHORTI_API_KEY"]})
      if (200...204).cover?(rsp.status)
        rsp.body.to_s
      else
        # not sure yet how to handle this error case
        nil
      end
    end
  end
end
