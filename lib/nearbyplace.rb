# frozen_string_literal: true

module CodePraise
  # Model for place
  class Nearbyplace
    def initialize(nearbyplace_data)
      @nearbyplace = nearbyplace_data
    end

    def name
      @nearbyplace['name']
    end

    def address
      @nearbyplace['vicinity']
    end

    def location
      @nearbyplace['geometry']['location']
    end

    def opening_now
      @nearbyplace['opening_hours']['open_now'] unless @nearbyplace['opening_hours'].nil?
    end

    def rating
      @nearbyplace['rating']
    end
  end
end
