require "yaml"

class FrontMatter
  attr_reader :body, :properties

  def initialize(text)
    @body = text
    parse
  end

  private

  def parse
    @body =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
    @properties = $1 ? YAML.load($1) : {}
    @body = $' if $1
  end
end
