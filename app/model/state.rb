# frozen_string_literal: true
require 'pry'
require_relative "search"

class State
  attr_accessor :sites, :query, :limit, :save_path, :progress, :logs

  def initialize
    @sites = "www.em.com.br"
    @query = '"mineradora OR mineração" + "evacuadas OR desalojadas OR removidas OR expulsas OR retiradas" + "famílias" -chuva'
    @limit = 10
    @save_path = ""
    @progress = 0
    @logs = []
  end

  def search_text
    site_query = @sites.split(" ").map do |site|
      "site:" + site
    end.join(" ")
    "#{site_query} #{@query}"
  end

  def submit_label
    "coletar #{@limit} resultados".upcase
  end

  def log_readout
    logs.join("\n")
  end

  def progress_max
    @limit + 3
  end

  def run_search
    progress_queue = Queue.new
    Thread.new do
      loop do
        event = progress_queue.deq
        self.progress += 1
        case event.first
        when :starting
          logs << "Iniciando pesquisa..."
        when :search_finished
          logs << "Pesquisa completa!"
          logs << "Coletando resultados..."
        when :url
          logs << "URL coletada: #{event[1]}"
        when :writing
          logs << "Coleta completa!"
          logs << "Escrevendo arquivo..."
        when :finished
          logs << "Terminado!"
          Thread.exit
        end
      end
    end
    Search.new(search_text, @sites.split(" "), @limit, @save_path).run progress_queue do |results|
      print @progress.to_s
    end
  end
end
