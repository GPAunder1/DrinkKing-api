# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'

describe 'get shop extractions test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_googlemap(recording: :new_episodes)
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end
  it 'recommend drink' do
    search_keyword = DrinkKing::Request::SearchKeyword.new(KEYWORD)
    DrinkKing::Service::AddShops.new.call(search_keyword: search_keyword)
    result = DrinkKing::Service::ExtractShop.new.call(shop_id: SHOPID)
    _(result.failure.message.to_s).must_include 'request_id'
    30.times { sleep(1) and print('.') }
    result = DrinkKing::Service::ExtractShop.new.call(shop_id: SHOPID)
    _(result.failure.message).must_equal RECOMMEND_DRINK
  end
end
