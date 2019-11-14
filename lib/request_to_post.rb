require "base64"

class RequestToPost
  attr_reader :file_path, :body, :properties, :valid, :content, :content_encoded

  def initialize(params)
    if params["body"]
      proccess_params(params)
    else
      @valid = false
    end
  end

  def valid?
    validate unless defined?(@valid)
    @valid
  end

  private

  def proccess_params(params)
    front_matter = FrontMatter.new(params.delete("body"))
    @body = front_matter.body
    @properties = front_matter.properties
    @properties["title"] ||= params.delete("title") || params.delete("subject")
    if @properties["date"]
      # need to understand why Yaml is adding .000000000 to the date
      @properties["date"] = Time.parse(@properties["date"].to_s).to_s
    end

    unless @properties["layout"]
      @properties["layout"] = "post"
    end

    generate_title_from_body if blank?(@properties["title"])

    if valid?
      @properties["date"] ||= Time.now.to_s
      @file_path = Slug.new(@properties["date"], @properties["title"]).to_slug

      params.each do |key, value|
        @properties[key] = value
      end

      # trying to correct for OS X \r\n
      @body = @body.delete("\r").gsub(/\n{2,}/, "\n\n").strip

      @content = <<~CONTENT
        #{@properties.keep_if { |key, value| value && value.to_s != "" }.to_yaml.strip}
        ---
        #{@body}
      CONTENT

      @content_encoded = Base64.encode64(@content)
    end
  end

  # If not title is present, try to create one
  # First, see if there are line breaks. We will assume the first line break
  # is the title.
  # If there are no line breaks, look for the first sentence.
  # And just because I am asking for trouble, remove the . if the title
  # ends with one
  def generate_title_from_body
    body_parts = body.split("\n").delete_if { |part| part.empty? }
    if body_parts.length > 1
      @properties["title"] = body_parts[0].strip
      @body = body_parts[1..-1].join("\n\n")
    elsif (index_of_punctuation = body.index(/\.|\!|\?/))
      @properties["title"] = body[0..index_of_punctuation].strip
      @body = body[(index_of_punctuation + 1)..-1].strip
    end

    if @properties["title"]&.end_with?(".")
      @properties["title"] = @properties["title"][0...-1]
    end
  end

  def blank?(string)
    (string || "").strip.empty?
  end

  def validate
    @valid = (!blank?(@body) && !blank?(properties["title"]))
  end
end
