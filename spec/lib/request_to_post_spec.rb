require_relative "../spec_helper"

describe RequestToPost do
  it "will use the body as is if there is no FrontMatter" do
    rp = RequestToPost.new("body" => "Body", "title" => "Title")
    expect(rp.body).to eql("Body")
  end

  it "will not be valid without a title" do
    r2p = RequestToPost.new("body" => "body")
    expect(r2p).to_not be_valid
  end

  it "will not be valid without a body" do
    r2p = RequestToPost.new("body" => "", "title" => "title")
    expect(r2p).to_not be_valid
  end

  it "will be valid with a body and title" do
    r2p = RequestToPost.new("body" => "body", "title" => "title")
    expect(r2p).to be_valid
  end

  it "will create a title from the body" do
    r2p = RequestToPost.new("body" => "This is the Title. Hello World")
    expect(r2p.properties["title"]).to eql("This is the Title")
    expect(r2p).to be_valid
  end

  it "will create a title from the body" do
    r2p = RequestToPost.new("body" => "This is the Title\n Hello World")
    expect(r2p.properties["title"]).to eql("This is the Title")
    expect(r2p).to be_valid
  end

  it "will create a title from the body and remove the period" do
    r2p = RequestToPost.new("body" => "This is the Title.\n Hello World")
    expect(r2p.properties["title"]).to eql("This is the Title")
    expect(r2p).to be_valid
  end

  it "will create a title from the body and keep a question mark" do
    r2p = RequestToPost.new("body" => "Is this worth the effort? Hello World")
    expect(r2p.properties["title"]).to eql("Is this worth the effort?")
    expect(r2p).to be_valid
  end

  it "will create a title from the body" do
    r2p = RequestToPost.new("body" => "This is the Title\n\n Hello World")
    expect(r2p.properties["title"]).to eql("This is the Title")
    expect(r2p).to be_valid
  end

  it "will set the file path" do
    fm = <<~FRONTMATTER
      ---
      title: File Path
      date: 2019-02-22 18:53:21 -0500
      ---
      Body
    FRONTMATTER
    r2p = RequestToPost.new("body" => fm)
    expect(r2p.file_path).to eql("_posts/2019-02-22-file-path.md")
  end

  it "will add used params to the front matter" do
    rp = RequestToPost.new("body" => "Body", "title" => "Title", "permalink" => "/hey-now")

    fm = FrontMatter.new(rp.content)
    expect(fm.properties["permalink"]).to eql("/hey-now")
  end
end
