# frozen_string_literal: true

module CodePraise
  # Model for place
  class Nearbyplace
    def initialize(nearbyplace_data)
      @nearbyplace = nearbyplace_data
    end

    def name
      @nearbyplace['name'] ||= ''
    end

    def address
      @nearbyplace['vicinity'] ||= ''
    end

    def location
      geometry = @nearbyplace['geometry']
      return '' unless geometry

      geometry['location']
    end

    def opening_now
      opening_hours = @nearbyplace['opening_hours']
      return '' unless opening_hours

      opening_hours['open_now']
    end

    def rating
      @nearbyplace['rating'] ||= ''
    end
  end
end
