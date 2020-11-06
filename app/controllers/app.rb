# frozen_string_literal: true

require 'roda'
require 'slim'

module CodePraise
  # The class is responible for routing the url
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets
      routing.root do
        view 'index'
      end

      routing.on 'shop' do
        routing.is do
          routing.post do
            shop_name = routing.params['drinking_shop']
            routing.redirect "shop/#{shop_name}"
          end
          # view 'shop'
        end
        routing.on String do |shop_name|
          routing.get do
            places = CodePraise::Googlemap::ShopMapper.new(App.config.api_token).find(shop_name)
            view 'shop', locals: { shops: places }
          end
        end
      end
    end
  end
end
