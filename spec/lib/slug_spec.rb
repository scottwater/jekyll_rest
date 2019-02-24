require_relative "../spec_helper"

describe Slug do
  it "will return a slug" do
    slug = Slug.new("2018-01-01", "Hello World").to_slug
    expect(slug).to eql("_posts/2018-01-01-hello-world.md")
  end

  it "will return a slug with a date" do
    slug = Slug.new(Time.new(2018, 0o2, 14), "Hello World").to_slug
    expect(slug).to eql("_posts/2018-02-14-hello-world.md")
  end
end
