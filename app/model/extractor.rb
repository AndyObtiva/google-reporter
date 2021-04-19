require 'open-uri'
require 'json'
require 'nokogiri'

class Extractor
  def initialize(url)
    @page     = URI.open(url)
    @document = Nokogiri::HTML(@page)
    begin
      @jsonld = JSON.parse(get_xpath_text("//script[@type='application/ld+json']"), symbolize_names: true)
    rescue TypeError
      # Ignored
    end
  end

  def to_hash
    {
      titulo:  title,
      chamada: description,
      url:     @page.base_uri,
      # 'corpo':   content,
      data: datetime
    }
  end

  def title
    select_first_valid(
      @jsonld&.dig(:headline),
      get_xpath_attribute("//meta[@itemprop='name'][@content]", 'content'),
      get_xpath_attribute("//meta[@itemprop='headline'][@content]", 'content'),
      get_xpath_attribute("//meta[@name='twitter:title'][@content]", 'content'),
      get_xpath_attribute("//meta[@property='og:title'][@content]", 'content'),
      get_xpath_text("//title")
    )
  end

  def author
    select_first_valid(
      @jsonld&.dig(:author, 0, :name),
      get_xpath_text("//*[@itemprop='author']//*[@itemprop='name']"),
      get_xpath_attribute("//meta[@itemprop='author'][@title]", 'title'),
      get_css_text('.author .name'),
      @jsonld&.dig(:publisher, :name)
    )
  end

  def datetime
    select_first_valid(
      @jsonld&.dig(:datePublished),
      get_xpath_attribute("//meta[@itemprop='datePublished'][@content]", 'content'),
      get_xpath_attribute("//meta[@name='DC.date.created'][@content]", 'content'),
      get_css_text('date')
    )
  end

  def description
    select_first_valid(
      @jsonld&.dig(:description),
      get_xpath_attribute("//meta[@name='abstract'][@content]", 'content'),
      get_xpath_attribute("//meta[@name='description'][@content]", 'content'),
      get_xpath_attribute("//meta[@itemprop='description'][@content]", 'content'),
      get_xpath_attribute("//meta[@name='twitter:description'][@content]", 'content'),
      get_xpath_attribute("//meta[@property='og:description'][@content]", 'content')
    )
  end

  def content
    select_first_valid(
      @document.xpath("//*[@itemprop='articleBody']//*[self::p or self::div]").text,
      get_css_text('articleBody'),
      @document.xpath("//article").text
    ).gsub(/[[:space:]]+/, ' ').strip
  end

  private

  def select_first_valid(*candidates)
    candidates.select(&:itself).reject(&:empty?).first
  end

  def get_xpath_attribute(path, attr)
    @document.xpath(path).first&.get_attribute(attr)
  end

  def get_xpath_text(path)
    @document.xpath(path).first&.text
  end

  def get_css_text(selector)
    @document.css(selector).first&.text
  end
end