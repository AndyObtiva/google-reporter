# frozen_string_literal: true
require 'open-uri'
require 'nokogiri'
require_relative 'extractor'

class Search
  def initialize(query, sites, limit, path)
    @query = query
    @sites = sites
    @limit = limit
    @path  = path
  end

  def run
    Thread.new do
      uri        = URI.parse('https://www.google.com/search')
      uri.query  = URI.encode_www_form({ q: @query })
      search_doc = Nokogiri::HTML(uri.open)
      @sites.each do |domain|
        search_doc.xpath("//a[starts-with(@href, '/url?q=https://#{domain}')]").each do |link|
          Thread.new do
            url       = link['href'].match(/\/url\?q=(\S+?)&/).captures.first
            extracted = Extractor.new(url)
            puts extracted.title
          end
        end
      end
    end
  end
end
