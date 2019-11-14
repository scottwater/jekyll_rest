require_relative "../spec_helper"

describe Slug do
  it "will return a slug" do
    slug = Slug.new("Hello World", "2018-01-01").to_slug
    expect(slug).to eql("_posts/2018-01-01-hello-world.md")
  end

  it "will return a slug with a date" do
    slug = Slug.new("Hello World", Time.new(2018, 2, 14)).to_slug
    expect(slug).to eql("_posts/2018-02-14-hello-world.md")
  end
end
