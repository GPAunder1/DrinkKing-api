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

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    opts[:root] = 'app/presentation/assets/'
    plugin :public, root: 'img'

    route do |routing|
      routing.assets
      routing.public

      # GET /
      routing.root do
        # Get visitor's search_word
        # session[:search_word].clear
        session[:search_word] ||= []

        result = Service::ListShops.new.call(session[:search_word])
        # different kind of shop names(ex:可不可, 鮮茶道)
        if result.failure?
          flash[:error] = result.failure
        else
          shops = result.value!
          display_shops = Views::ShopsList.new(shops)
        end

        view 'index', locals: { shops: display_shops, records: session[:search_word] }
      end

      routing.on 'shop' do
        routing.is do
          # POST /shop/
          routing.post do
            search_word = routing.params['drinking_shop']
            keyword_request = DrinkKing::Forms::SearchKeyword.new.call(search_keyword: search_word)
            shops_made = DrinkKing::Service::AddShops.new.call(keyword_request)

            if shops_made.failure?
              flash[:error] = shops_made.failure
              routing.redirect '/'
            end

            session[:search_word].insert(0, search_word).uniq!
            # Redirect to search result page
            routing.redirect "shop/#{search_word}"
          end
        end

        routing.on String do |search_word|
          # GET /shop/{search_word}
          routing.get do

            result = DrinkKing::Service::ProcessShops.new.call(search_keyword: search_word)

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            else
              shops = result.value!

              display_shops = Views::ShopsList.new(shops[:shops], shops[:recommend_drinks], shops[:menu])
            end


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
