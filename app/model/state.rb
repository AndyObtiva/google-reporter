# frozen_string_literal: true

require_relative 'search'

class State
  attr_accessor :sites, :query, :limit
  attr_writer :save_path
  attr_reader :progress, :logs

  def initialize
    @sites     = 'www.em.com.br'
    @query     = '"mineradora OR mineração" + "evacuadas OR desalojadas OR removidas OR expulsas OR retiradas" + "famílias" -chuva'
    @limit     = 10
    @save_path = ''
    @progress  = 0
    @logs      = []
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

  def run_search
    progress_queue = Queue.new
    Thread.new do
      loop do
        puts 'Queue 1'
        event = progress_queue.deq
        puts event
        case event.to_a.first
        when :url
          @progress += 1
          @logs << "URL: #{event[:url]}"
        when :writing
          @logs << "Coleta completa!"
          @progress += 1
          @logs << "Escrevendo arquivo..."
        when :finished
          @logs << "Terminado!"
          Thread.exit
        end
      end
    end
    @logs << "Coletando resultados..."
    Search.new(search_text, @sites.split(' '), @limit, @save_path).run progress_queue do |results|
    end
  end
end
