# frozen_string_literal: true

class State
  attr_accessor :sites, :query, :limit, :loading

  def initialize
    @sites   = []
    @query   = ''
    @limit   = 10
    @loading = false
  end
end
