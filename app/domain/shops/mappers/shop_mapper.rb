# frozen_string_literal: true

require_relative 'parser'

module DrinkKing
  module Googlemap
    # Data Mapper: Googlemap nearbyplace -> Shop entity
    class ShopMapper
      def initialize(token, gateway_class = Googlemap::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(keyword)
        # future extension:current location
        data = @gateway.nearbyplaces_data(keyword, [24.7961217, 120.9966699])
        Parsers::ApiResponse.new(data).apierror? ? build_entity(data) : raise_error(data)
      end

      def build_entity(data)
        data.map { |place| DataMapper.new(place, @token, @gateway_class).build_entity }
      end

      def raise_error(error_string)
        error_string
      end
    end

    # Extracts entity specific elements from data structure
    class DataMapper
      def initialize(data, token, gateway_class)
        @data = data
        @shop_details_mapper = ShopDetailMapper.new(token, gateway_class)
        @shop_details = @shop_details_mapper.find_by_placeid(@data['place_id'])
      end

      def build_entity
        DrinkKing::Entity::Shop.new(
          id: nil,
          placeid: placeid,
          name: name,
          address: address,
          latitude: latitude,
          longitude: longitude,
          phone_number: phone_number,
          map_url: map_url,
          opening_now: opening_now,
          rating: rating,
          reviews: reviews
        )
      end

      private

      def placeid
        @data['place_id'] ||= nil
      end

      def name
        @data['name'] ||= nil
      end

      def address
        @shop_details['formatted_address'] ||= nil
      end

      def longitude
        geometry = @data['geometry']
        return nil unless geometry

        geometry['location']['lng']
      end

      def latitude
        geometry = @data['geometry']
        return nil unless geometry

        geometry['location']['lat']
      end

      def phone_number
        @shop_details['formatted_phone_number'] ||= nil
      end

      def map_url
        @shop_details['url']
      end

      def opening_now
        opening_hours = @data['opening_hours']
        return nil unless opening_hours

        opening_hours['open_now'] ? 'opening' : 'closed'
        # future extension: add opening hours(already inside called api)
      end

      def rating
        @data['rating'] ||= nil
      end

      def reviews
        ShopDetailMapper.build_review_entity(@shop_details['reviews'])
      end
    end
  end
end
