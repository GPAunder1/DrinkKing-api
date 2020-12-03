# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# 不確定要不要這個檔案，先建個
module DrinkKing
  module Representer
    # Represent drink as json
    class Drink < Roar::Decorator
      include Roar::JSON

      property :name
      property :english_name
      property :price

    end
  end
end
