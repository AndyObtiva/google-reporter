# frozen_string_literal: true

require_relative 'search'

class State
  attr_writer :save_path
  attr_accessor :sites, :query, :limit, :loading

  def initialize
    @sites   = ''
    @query   = ''
    @limit   = 10
    @loading = false
  end

  def search_text
    site_query = @sites.split(' ').map do |site|
      'site:' + site
    end.join(' ')
    "#{site_query} #{@query}"
  end

  def submit_label
    "coletar #{@limit} resultados".upcase
  end

  def search
    Search.new(search_text, @sites.split(' '), @limit, @save_path)
  end
end
