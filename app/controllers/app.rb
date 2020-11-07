# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # The class is responible for routing the url
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing

    route do |routing|
      routing.assets

      routing.root do
        shops = Repository::For.klass(Entity::Shop).all
        view 'index', locals: { shops: shops }
      end

      routing.on 'shop' do
        routing.is do
          # GET /shop/
          routing.post do
            search_word = routing.params['drinking_shop']

            # Get shop from Google Map
            places = CodePraise::Googlemap::ShopMapper.new(App.config.api_token).find(search_word)

            # Add shop to database
            places.map { |place| Repository::For.entity(place).create(place) }

            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end
        routing.on String do |search_word|
          routing.get do
            # Get shops from database instead of Google Map
            shops = Repository::For.klass(Entity::Shop).find_shop(search_word)
            # Show shops
            view 'shop', locals: { shops: shops }
          end
        end
      end
    end
  end
end
