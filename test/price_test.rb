require 'test_helper'

class TestPrice < Minitest::Test
  def test_find_price
    VCR.use_cassette('price') do
      expected_resp = {
        "BTC" => {
          "USD" => 2606.73
        }
      }

    price_resp = Cryptocompare::Price.find('BTC', 'USD')

    assert price_resp.kind_of?(Hash)
    assert_equal expected_resp, price_resp
    end
  end
end
