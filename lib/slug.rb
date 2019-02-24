require "date"
class Slug
  STOP_WORDS = %w[til ntm a an and are as at be but by for if in into is it no of on or such that the their then there these they this to s was will with]

  attr_reader :date, :title

  def initialize(date, title)
    @date = if date.is_a?(String)
      Date.parse(date)
    else
      date
    end

    @title = title
  end

  def to_slug
    slug = title
      .downcase
      .gsub(/[\W_]/, " ")
      .split(" ")
      .select {|s| s unless s.empty?}
      .collect {|s| s unless STOP_WORDS.include?(s)}
      .join(" ")
      .strip
    "_posts/#{@date.to_date}-#{slug.gsub(/ +/, "-")}.md"
  end
end
