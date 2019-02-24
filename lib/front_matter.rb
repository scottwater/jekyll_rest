require "yaml"

class FrontMatter
  attr_reader :body, :properties

  def initialize(text)
    @body = text
    @properties = {}
    parse
  end

  def parse
    @body =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
    @properties = YAML.load($1) if $1
    @body = $' if $1
  end
end
