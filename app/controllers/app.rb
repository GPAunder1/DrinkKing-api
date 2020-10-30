# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # Roda
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :halt

    route do |routing|

      routing.root do
        view 'index'
      end

      # routing.on
    end
  end
end
