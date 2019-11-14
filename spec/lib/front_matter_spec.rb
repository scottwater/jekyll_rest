require_relative "../spec_helper"

describe FrontMatter do
  it "will be just the body param if there is no YAML" do
    front_matter = FrontMatter.new("BODY")
    expect(front_matter.body).to eql("BODY")
  end

  it "will have an no properties without a FrontMatter" do
    front_matter = FrontMatter.new("BODY")
    expect(front_matter.properties).to be_empty
  end

  it "will find some front matter" do
    fm = <<~FRONTMATTER
      ---
      title: HEY
      ---
      Body
    FRONTMATTER

    front_matter = FrontMatter.new(fm)
    expect(front_matter.body).to eql("Body\n")
    expect(front_matter.properties["title"]).to eql("HEY")
  end
end
