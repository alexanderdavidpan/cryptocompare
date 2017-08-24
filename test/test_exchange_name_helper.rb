require 'test_helper'

class TestExchangeNameHelper < Minitest::Test
  def test_set_exchange_name_case_insensitive
    Cryptocompare::ExchangeNameHelper::EXCHANGES.each do |_, v|
      random_casing = v.gsub(/./){|s| s.send(%i[upcase downcase].sample)}
      assert_equal v, Cryptocompare::ExchangeNameHelper.set_exchange(random_casing)
    end
  end

  def test_set_exchange_name_tries_user_input_if_no_exchange_mapping_found
    assert_equal 'YoloTrade', Cryptocompare::ExchangeNameHelper.set_exchange('YoloTrade')
  end
end
