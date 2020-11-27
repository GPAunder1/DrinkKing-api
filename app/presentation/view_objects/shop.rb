# frozen_string_literal: true

module Views
  # View for shop and shop extractions(recommend drink, menu) for a given shop
  class Shop
    def initialize(shop, recommend_drink = nil, menu = nil)
      @shop = shop
      @recommend_drink = recommend_drink
      @menu = menu
    end

    def entity
      @shop
    end

    def name
      @shop.name
    end

    def address
      @shop.address
    end

    def latitude
      @shop.latitude
    end

    def longitude
      @shop.longitude
    end

    def phone_number
      @shop.phone_number
    end

    def map_url
      @shop.map_url
    end

    def opening_now
      @shop.opening_now
    end

    def rating
      @shop.rating
    end

    def reviews
      @shop.reviews.map { |review| Review.new(review) }
    end

    def recommend_drink
      @recommend_drink
    end

    def menu
      @menu
    end

    def json_format_to_js
      format_shop = @shop.to_h
      format_shop[:recommend_drink] = @recommend_drink
      format_shop[:menu] = @menu
      format_shop.to_json
    end
  end
end
