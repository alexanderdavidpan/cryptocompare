require 'test_helper'

class TestExchanges < Minitest::Test
  def test_exchanges_all
    VCR.use_cassette('all_exchanges') do
      all_exchanges_resp = Cryptocompare::Exchanges.all

      assert all_exchanges_resp.kind_of?(Hash)

      # Use coinbase data as test example for data format
      coinbase_data = all_exchanges_resp['Coinbase']
      assert coinbase_data.kind_of?(Hash)
      assert coinbase_data.keys.sort, ['BCH', 'BTC', 'ETC', 'LTC']

      coinbase_data.each do |_, v|
        assert v.kind_of?(Array)
      end
    end
  end
end
