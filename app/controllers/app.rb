# frozen_string_literal: true

require 'roda'
require 'slim/include'

module CodePraise
  # The class is responible for routing the url
  class App < Roda
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :render, engine: 'slim', views: 'app/presentation/views_html/'
    plugin :assets, path: 'app/presentation/assets/',
                    css: 'style.css', js: ['config.js', 'map.js', 'shop.js']
    plugin :halt
    plugin :unescape_path # decodes a URL-encoded path before routing

    opts[:root] = 'app/presentation/assets/'
    plugin :public, root: 'img'

    route do |routing|
      routing.assets
      routing.public
      routing.root do
        # Get visitor's search_word
        # session[:search_word].clear
        session[:search_word] ||= []
        puts "------------------#{session[:search_word][0]}"
        shops = Repository::For.klass(Entity::Shop).all
        view 'index', locals: { shops: shops, records: session[:search_word] }
      end

      routing.on 'shop' do
        routing.is do
          # GET /shop/
          routing.post do
            search_word = routing.params['drinking_shop']

            session[:search_word].insert(0, search_word).uniq!
            # Get shop from Google Map
            places = CodePraise::Googlemap::ShopMapper.new(App.config.API_TOKEN).find(search_word)
            if places.is_a? String
              flash[:error] = places
              routing.redirect '/'
            end

            #Add shop to database
            places.map { |place| Repository::For.entity(place).find_or_create(place) }

            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end
        routing.on String do |search_word|
          routing.get do
            # Get shops from database instead of Google Map
            begin
              shops = Repository::For.klass(Entity::Shop).find_shop(search_word)
              rescue StandardError => e
              puts e.backtrace.join("\n")
              flash[:error] = 'Having trouble accessing the database'
            end
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
