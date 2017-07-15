require 'test_helper'

class TestPrice < Minitest::Test
  def test_find_price_cryptocurrency_to_fiat
    VCR.use_cassette('btc_to_usd') do
      expected_resp = {
        "BTC" => {
          "USD" => 2561.88
        }
      }

    price_resp = Cryptocompare::Price.find('BTC', 'USD')

    assert price_resp.kind_of?(Hash)
    assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_fiat_to_cryptocurrency
    VCR.use_cassette('usd_to_eth') do
      expected_resp = {
        "USD" => {
          "ETH" => 0.004068
        }
      }

    price_resp = Cryptocompare::Price.find('USD', 'ETH')

    assert price_resp.kind_of?(Hash)
    assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_cryptocurrency_to_cryptocurrency
    VCR.use_cassette('btc_to_eth') do
      expected_resp = {
        "BTC" => {
          "ETH" => 10.55
        }
      }

      price_resp = Cryptocompare::Price.find('BTC', 'ETH')

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_fiat_to_fiat
    VCR.use_cassette('usd_to_eur') do
      expected_resp = {
        "USD" => {
          "EUR" => 0.8772
        }
      }

      price_resp = Cryptocompare::Price.find('USD', 'EUR')

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_multiple_cryptocurrencies_to_multiple_fiat
    VCR.use_cassette('mult_cc_to_mult_fiat') do
      expected_resp = {
        "BTC" => {
          "USD" => 2513.55,
          "EUR" => 2204.92,
          "CNY" => 17441.13
        },
        "ETH" => {
          "USD" => 236.99,
          "EUR" => 207.93,
          "CNY" => 1653.72
        },
        "LTC" => {
          "USD" => 48.46,
          "EUR" => 42.61,
          "CNY" => 336.34
        }
      }

      price_resp = Cryptocompare::Price.find(['BTC','ETH', 'LTC'], ['USD', 'EUR', 'CNY'])

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_multiple_fiat_to_multiple_cryptocurrencies
    VCR.use_cassette('mult_fiat_to_mult_cc') do
      expected_resp = {
        "USD" => {
          "BTC" => 0.0004232,
          "ETH" => 0.004826
        },
        "EUR" => {
          "BTC" => 0.0004839,
          "ETH" => 0.005518
        }
      }

      price_resp = Cryptocompare::Price.find(['USD', 'EUR'], ['BTC','ETH'])

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end

  def test_find_price_cryptocurrency_to_fiat_using_exchange_option
    VCR.use_cassette('eth_to_usd_coinbase') do
      expected_resp = {
        "ETH" => {
          "USD" => 191.45
        }
      }

      price_resp = Cryptocompare::Price.find('ETH', 'USD', {'e' => 'Coinbase'})

      assert price_resp.kind_of?(Hash)
      assert_equal expected_resp, price_resp
    end
  end
end
