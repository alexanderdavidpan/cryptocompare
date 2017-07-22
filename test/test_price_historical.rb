require 'test_helper'

class TestPriceHistorical < Minitest::Test
  def test_find_price_historical_cryptocurrency_to_another_currency
    VCR.use_cassette('eth_to_usd_historical') do
      expected_resp = {
        "ETH" => {
          "USD" => 224.65
        }
      }

      price_resp = Cryptocompare::PriceHistorical.find('ETH', 'USD')

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_historical_cryptocurrency_to_another_currency_at_timestamp
    VCR.use_cassette('eth_to_usd_historical_timestamp') do
      expected_resp = {
        "ETH" => {
          "USD" => 1.13
        }
      }

      price_resp = Cryptocompare::PriceHistorical.find('ETH', 'USD', {'ts' => '1452680400'})

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_historical_cryptocurrency_to_multiple_currencies_at_timestamp_string
    VCR.use_cassette('eth_to_multiple_currencies_historical_timestamp') do
      expected_resp = {
        "ETH" => {
          "BTC" => 0.002616,
          "USD" => 1.13,
          "EUR" => 1.04
        }
      }

      price_resp = Cryptocompare::PriceHistorical.find('ETH', ['BTC', 'USD', 'EUR'], {'ts' => '1452680400'})

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_historical_cryptocurrency_to_multiple_currencies_at_timestamp_integer
    VCR.use_cassette('eth_to_multiple_currencies_historical_timestamp') do
      expected_resp = {
        "ETH" => {
          "BTC" => 0.002616,
          "USD" => 1.13,
          "EUR" => 1.04
        }
      }

      price_resp = Cryptocompare::PriceHistorical.find('ETH', ['BTC', 'USD', 'EUR'], {'ts' => 1452680400})

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end
end
