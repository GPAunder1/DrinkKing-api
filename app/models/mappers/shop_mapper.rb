# frozen_string_literal: true

require_relative 'parser'

module CodePraise
  module Googlemap
    # Data Mapper: Googlemap nearbyplace -> Shop entity
    class ShopMapper
      def initialize(token, gateway_class = Googlemap::Api)
        @token = token
        @gateway = gateway_class.new(@token)
      end

      def find(keyword)
        # future extension:current location
        data = @gateway.nearbyplaces_data(keyword, [24.7961217, 120.9966699])
        Parsers::ApiResponse.new(data).apierror? ? ShopMapper.build_entity(data) : raise_error(data)
      end

      def self.build_entity(data)
        data.map { |place| DataMapper.new(place).build_entity }
      end

      def raise_error(error_string)
        error_string
      end
    end

    # Extracts entity specific elements from data structure
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        CodePraise::Entity::Shop.new(
          id: id,
          name: name,
          address: address,
          location: location,
          opening_now: opening_now,
          rating: rating
        )
      end

      private
      def id
        @data['place_id'] ||= nil
      end

      def name
        @data['name'] ||= nil
      end

      def address
        @data['vicinity'] ||= nil
      end

      def location
        geometry = @data['geometry']
        return nil unless geometry

        geometry['location']
      end

      def opening_now
        opening_hours = @data['opening_hours']
        return nil unless opening_hours

        opening_hours['open_now'] ? "opening" : "closed"
      end

      def rating
        @data['rating'] ||= nil
      end
    end
  end
end
