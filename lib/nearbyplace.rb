# frozen_string_literal: true

module CodePraise
  # Model for place
  class Nearbyplace
    def initialize(nearbyplace_data)
      @nearbyplace = nearbyplace_data
    end

    def name
      @nearbyplace['name'].nil? ? '' : @nearbyplace['name']
    end

    def address
      @nearbyplace['vicinity'].nil? ? '' : @nearbyplace['vicinity']
    end

    def location
      @nearbyplace['geometry']['location'].nil? ? '' : @nearbyplace['geometry']['location']
    end

    def opening_now
      @nearbyplace['opening_hours'].nil? ? '' : @nearbyplace['opening_hours']['open_now']
    end

    def rating
      @nearbyplace['rating'].nil? ? '' : @nearbyplace['rating']
    end
  end
end
