# frozen_string_literal: true
require 'open-uri'
require 'csv'
require 'nokogiri'
require_relative 'extractor'

class Search
  HEADERS = [:titulo, :chamada, :url, :data]

  # @param [String] query Full search string
  # @param [Array] sites Array of website domains
  # @param [Integer] limit Max number of results to extract
  # @param [String] path Path to save CSV results
  def initialize(query, sites, limit, path)
    @query = query
    @sites = sites
    @limit = limit
    @path  = path
  end

  # @param [Queue] progress Progress event queue
  # @param [Proc] callback Callback with resulting extractors
  def run(progress, &callback)
    Thread.new do
      uri        = URI.parse('https://www.google.com.br/search')
      uri.query  = URI.encode_www_form({ q: @query })
      search_doc = Nokogiri::HTML(uri.open)

      results = @sites.map do |domain|
        search_doc.xpath("//a[starts-with(@href, '/url?q=https://#{domain}')]").map do |link|
          Thread.new do
            url       = link['href'].match(/\/url\?q=(\S+?)&/).captures.first
            extractor = Extractor.new url
            progress.enq({ url: url })
            extractor
          end
        end
      end.flatten.map(&:value)

      progress.enq({ writing: true })
      CSV.open @path, 'wb', headers: HEADERS, write_headers: true do |csv|
        results.each { |r| csv << r.to_hash }
      end
      progress.enq({ finished: true })
      callback.call results
    end
  end
end
