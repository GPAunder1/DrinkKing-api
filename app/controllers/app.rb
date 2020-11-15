# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # The class is responible for routing the url
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: ['config.js', 'map.js', 'shop.js']
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing

    opts[:root] = 'app/views/assets/'
    plugin :public, root: 'img'

    route do |routing|
      routing.assets
      routing.public
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
            places.map { |place| Repository::For.entity(place).find_or_create(place) }

            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end
        routing.on String do |search_word|
          routing.get do
            # Get shops from database instead of Google Map
            shops = Repository::For.klass(Entity::Shop).find_shop(search_word)

            file = File.read('./app/domain/extraction/values/drinks.json')
            menu = JSON.parse(file)['drinks'].to_json
            # 目前跑很久，暫時只跑第一筆
            recommend_drinks = []
            recommend_drink = CodePraise::Mapper::ReviewsExtractionMapper.find_by_shopname(shops[0].name).recommend_drink
            shops.map do |shop|
              recommend_drinks << recommend_drink
            end

            # Show shops
            view 'shop', locals: { shops: shops , recommend_drinks: recommend_drinks, menu: menu}
          end
        end
      end

      routing.on 'test' do
        shops = Repository::For.klass(Entity::Shop).all
        view 'test', locals: { shops: shops }
      end
    end
  end
end
