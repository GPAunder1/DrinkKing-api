# frozen_string_literal: true

require 'roda'
require 'slim/include'

module DrinkKing
  # The class is responible for routing the url
  class App < Roda
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :render, engine: 'slim', views: 'app/presentation/views_html/'
    plugin :assets, path: 'app/presentation/assets/',
                    css: 'style.css', js: ['map.js', 'shop.js']
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

        # shops = Repository::For.klass(Entity::Shop).all
        # different kind of shop names(ex:可不可, 鮮茶道)
        shops = Repository::For.klass(Entity::Shop).find_many_shops(session[:search_word])
        display_shops = Views::ShopsList.new(shops)
        view 'index', locals: { shops: display_shops, records: session[:search_word] }
      end

      routing.on 'shop' do
        routing.is do
          # POST /shop/
          routing.post do
            search_word = routing.params['drinking_shop']
            checklist = %w[飲料 可不可 鮮茶道 大苑子 荔枝烏龍 胭脂多多]
            unless checklist.include? search_word
              flash[:error] = 'Please enter keyword related to drink'
              routing.redirect '/'
            end

            # Get shop from Google Map API
            places = DrinkKing::Googlemap::ShopMapper.new(App.config.API_TOKEN).find(search_word)

            # Error message get from API response
            if places.is_a? String
              flash[:error] = 'Error with Gmap API: ' + places
              routing.redirect '/'
            end

            # Add shop to database
            begin
              places.map { |place| Repository::For.entity(place).find_or_create(place) }
            rescue StandardError => error
              puts error.backtrace.join("\n")
              flash[:error] = 'Having trouble accessing the database'
            end

            session[:search_word].insert(0, search_word).uniq!
            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end

        routing.on String do |search_word|
          # GET /shop/{search_word}
          routing.get do
            # Get shops from database instead of Google Map
            begin
              shops = Repository::For.klass(Entity::Shop).find_shop(search_word)
              if shops[0].nil?
                flash[:error] = 'No shop is found!'
                routing.redirect '/'
              end
            rescue StandardError => e
              puts e.backtrace.join("\n")
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end

            # Load Menu from json file
            begin
              file = File.read('./app/domain/extraction/values/drinks.json')
              menu = JSON.parse(file)['drinks']
              if menu == 'null'
                flash[:error] = 'No menu is found'
                routing.redirect '/'
              end
            end

            # Get recommond drinks
            begin
              # 目前跑很久，暫時只跑第一筆
              recommend_drinks = []
              shops.map do |shop|
                recommend_drink = Mapper::ReviewsExtractionMapper.find_by_shopname(shop.name).recommend_drink
                recommend_drinks << recommend_drink
              end

            rescue StandardError
              flash[:error] = 'Error with getting recommend drink'
              routing.redirect '/'
            end

            # Show shops
            display_shops = Views::ShopsList.new(shops, recommend_drinks, menu)
            view 'shop', locals: { shops: display_shops }
            # view 'shop', locals: { shops: shops , recommend_drinks: recommend_drinks, menu: menu}
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
