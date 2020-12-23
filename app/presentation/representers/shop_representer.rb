# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'review_representer'
require_relative 'menu_representer'

module DrinkKing
  module Representer
    # Represent a shop entity as json
    class Shop < Roar::Decorator
      include Roar::JSON

      property :placeid
      property :name
      property :address
      property :latitude
      property :longitude
      property :phone_number
      property :map_url
      property :opening_now
      property :rating
      property :recommend_drink
      property :menu, extend: Representer::Menu, class: OpenStruct
      collection :reviews, extend:Representer::Review, class: OpenStruct

    end
  end
end
