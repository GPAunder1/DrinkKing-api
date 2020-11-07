# frozen_string_literal: true

module CodePraise
  # For class
  module Repository
    class For
      ENTITY_REPOSITORY = {
        Entity::Shop => Shops,
        Entity::Review => Reviews
      }.freeze
    end

    def self.klass(entity_klass)
      ENTITY_REPOSITORY[entity_klass]
    end

    def self.entity(entity_object)
      ENTITY_REPOSITORY[entity_object.class]
    end
  end
end
