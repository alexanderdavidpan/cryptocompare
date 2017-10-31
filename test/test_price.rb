require 'test_helper'

class TestPrice < Minitest::Test
  PRICE_FULL_RAW_KEYS = %w[
    TYPE
    MARKET
    FROMSYMBOL
    TOSYMBOL
    FLAGS
    PRICE
    LASTUPDATE
    LASTVOLUME
    LASTVOLUMETO
    LASTTRADEID
    VOLUME24HOUR
    VOLUME24HOURTO
    OPEN24HOUR
    HIGH24HOUR
    LOW24HOUR
    LASTMARKET
    CHANGE24HOUR
    CHANGEPCT24HOUR
    SUPPLY
    MKTCAP
  ].freeze

  PRICE_FULL_DISPLAY_KEYS = %w[
    FROMSYMBOL
    TOSYMBOL
    MARKET
    PRICE
    LASTUPDATE
    LASTVOLUME
    LASTVOLUMETO
    LASTTRADEID
    VOLUME24HOUR
    VOLUME24HOURTO
    OPEN24HOUR
    HIGH24HOUR
    LOW24HOUR
    LASTMARKET
    CHANGE24HOUR
    CHANGEPCT24HOUR
    SUPPLY
    MKTCAP
  ].freeze

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

  def test_price_full
    VCR.use_cassette('btc_to_usd_full') do
      price_full_resp = Cryptocompare::Price.full('BTC', 'USD')

      assert price_full_resp
      assert price_full_resp.kind_of?(Hash)

      raw_resp     = price_full_resp['RAW']
      display_resp =  price_full_resp['DISPLAY']

      assert raw_resp
      assert raw_resp.kind_of?(Hash)
      assert display_resp
      assert display_resp.kind_of?(Hash)

      assert_equal ['BTC'], raw_resp.keys
      assert_equal ['BTC'], display_resp.keys

      assert_equal ['USD'], raw_resp['BTC'].keys
      assert_equal ['USD'], display_resp['BTC'].keys

      assert_equal 'BTC', raw_resp['BTC']['USD']['FROMSYMBOL']
      assert_equal 'USD', raw_resp['BTC']['USD']['TOSYMBOL']
      assert_equal 'Ƀ', display_resp['BTC']['USD']['FROMSYMBOL']
      assert_equal '$', display_resp['BTC']['USD']['TOSYMBOL']

      assert_empty raw_resp['BTC']['USD'].keys - PRICE_FULL_RAW_KEYS
      assert_empty display_resp['BTC']['USD'].keys - PRICE_FULL_DISPLAY_KEYS
    end
  end

  def test_price_multi_full_using_e_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC&tsyms=USD&e=Coinbase')
      .to_return(:status => 200, :body => basic_price_full_json_response)

    Cryptocompare::Price.full('BTC', 'USD', {'e' => 'Coinbase'})
  end

  def test_price_multi_full_using_tc_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC&tsyms=USD&tryConversion=false')
      .to_return(:status => 200, :body => basic_price_full_json_response)

    Cryptocompare::Price.full('BTC', 'USD', {'tc' => false})
  end

  def test_price_generate_avg
    VCR.use_cassette('btc_to_usd_generate_avg') do
      expected_resp = JSON.parse(basic_generate_avg_json_response)

      generate_avg_resp = Cryptocompare::Price.generate_avg('BTC', 'USD', 'Coinbase')

      assert generate_avg_resp.kind_of?(Hash)
      assert_equal expected_resp, generate_avg_resp
    end
  end

  def test_price_generate_avg_using_markets_option_as_string_or_array_of_strings
    # Markets as a String
    stub_request(:get, 'https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&markets=Coinbase')
      .to_return(:status => 200, :body => basic_generate_avg_json_response)

    Cryptocompare::Price.generate_avg('BTC', 'USD', 'Coinbase')

    # Markets as an Array of strings
    stub_request(:get, 'https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&markets=Coinbase,Poloniex')
      .to_return(:status => 200, :body => basic_generate_avg_json_response)

    Cryptocompare::Price.generate_avg('BTC', 'USD', ['Coinbase', 'Poloniex'])
  end

  def test_price_generate_avg_using_tc_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/generateAvg?fsym=BTC&tsym=USD&markets=Coinbase&tryConversion=false')
      .to_return(:status => 200, :body => basic_generate_avg_json_response)

    Cryptocompare::Price.generate_avg('BTC', 'USD', 'Coinbase', {'tc' => false})
  end

  def test_price_day_avg
    VCR.use_cassette('btc_to_usd_day_avg') do
      expected_resp = {
        "USD" => 4576.46,
        "ConversionType" => {
          "type" => "direct",
          "conversionSymbol" => ""
        }
      }

      day_avg_resp = Cryptocompare::Price.day_avg('BTC', 'USD')

      assert day_avg_resp.kind_of?(Hash)
      assert_equal expected_resp, day_avg_resp
    end
  end

  def test_price_day_avg_using_exchange_option
    VCR.use_cassette('btc_to_usd_day_avg_coinbase') do
      expected_resp = {
        "USD" => 4581.66,
        "ConversionType" => {
          "type" => "force_direct",
          "conversionSymbol" => ""
        }
      }

      day_avg_resp = Cryptocompare::Price.day_avg('BTC', 'USD', {'e' => 'Coinbase'})

      assert day_avg_resp.kind_of?(Hash)
      assert_equal 'force_direct', day_avg_resp['ConversionType']['type']
      assert_equal expected_resp, day_avg_resp
    end
  end

  def test_price_day_avg_using_tc_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/dayAvg?fsym=BTC&tsym=USD&tryConversion=false')
      .to_return(:status => 200, :body => basic_day_avg_json_response)

    Cryptocompare::Price.day_avg('BTC', 'USD', {'tc' => false})
  end

  def test_price_day_avg_using_to_ts_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/dayAvg?fsym=BTC&tsym=USD&toTs=1502514000')
      .to_return(:status => 200, :body => basic_day_avg_json_response)

    Cryptocompare::Price.day_avg('BTC', 'USD', {'to_ts' => 1502514000})
  end

  def test_price_day_avg_using_utc_offset_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/dayAvg?fsym=BTC&tsym=USD&UTCHourDiff=-8')
      .to_return(:status => 200, :body => basic_day_avg_json_response)

    Cryptocompare::Price.day_avg('BTC', 'USD', {'utc_offset' => -8})
  end

  private

  def basic_price_full_json_response
    {
      "RAW" => {
        "BTC" => {
          "USD" => {
            "TYPE"=>"5",
            "MARKET"=>"CCCAGG",
            "FROMSYMBOL"=>"BTC",
            "TOSYMBOL"=>"USD",
            "FLAGS"=>"4",
            "PRICE"=>4551.84,
            "LASTUPDATE"=>1504753702,
            "LASTVOLUME"=>2.19e-06,
            "LASTVOLUMETO"=>0.00995355,
            "LASTTRADEID"=>20466080,
            "VOLUME24HOUR"=>110449.85666195827,
            "VOLUME24HOURTO"=>503369392.8440719,
            "OPEN24HOUR"=>4497.45,
            "HIGH24HOUR"=>4667.51,
            "LOW24HOUR"=>4386.51,
            "LASTMARKET"=>"Coinbase",
            "CHANGE24HOUR"=>54.39000000000033,
            "CHANGEPCT24HOUR"=>1.2093519661141388,
            "SUPPLY"=>16549137,
            "MKTCAP"=>75329023762.08
          }
        }
      },
      "DISPLAY" => {
        "BTC" => {
          "USD" => {
            "FROMSYMBOL"=>"Ƀ",
            "TOSYMBOL"=>"$",
            "MARKET"=>"CryptoCompare Index",
            "PRICE"=>"$ 4,551.84",
            "LASTUPDATE"=>"Just now",
            "LASTVOLUME"=>"Ƀ 0.00000219",
            "LASTVOLUMETO"=>"$ 0.009954",
            "LASTTRADEID"=>20466080,
            "VOLUME24HOUR"=>"Ƀ 110,449.9",
            "VOLUME24HOURTO"=>"$ 503,369,392.8",
            "OPEN24HOUR"=>"$ 4,497.45",
            "HIGH24HOUR"=>"$ 4,667.51",
            "LOW24HOUR"=>"$ 4,386.51",
            "LASTMARKET"=>"Coinbase",
            "CHANGE24HOUR"=>"$ 54.39",
            "CHANGEPCT24HOUR"=>"1.21",
            "SUPPLY"=>"Ƀ 16,549,137",
            "MKTCAP"=>"$ 75.33 B"
          }
        }
      }
    }.to_json
  end

  def basic_generate_avg_json_response
    {
      "RAW" => {
        "MARKET" => "CUSTOMAGG",
        "FROMSYMBOL" => "BTC",
        "TOSYMBOL" => "USD",
        "FLAGS" => 0,
        "PRICE" => 4588.37,
        "LASTUPDATE" => 1504134812,
        "LASTVOLUME" => 2.17e-06,
        "LASTVOLUMETO" => 0.009956762899999999,
        "LASTTRADEID" => 20028850,
        "VOLUME24HOUR" => 9915.240758770035,
        "VOLUME24HOURTO" => 45407674.35622524,
        "OPEN24HOUR" => 4599,
        "HIGH24HOUR" => 4635.21,
        "LOW24HOUR" => 4500.55,
        "LASTMARKET" => "Coinbase",
        "CHANGE24HOUR" => -10.63000000000011,
        "CHANGEPCT24HOUR" => -0.23113720373994584
      },
      "DISPLAY" => {
        "FROMSYMBOL" => "Ƀ",
        "TOSYMBOL" => "$",
        "MARKET" => "CUSTOMAGG",
        "PRICE" => "$ 4,588.37",
        "LASTUPDATE" => "Just now",
        "LASTVOLUME" => "Ƀ 0.00000217",
        "LASTVOLUMETO" => "$ 0.009957",
        "LASTTRADEID" => 20028850,
        "VOLUME24HOUR" => "Ƀ 9,915.24",
        "VOLUME24HOURTO" => "$ 45,407,674.4",
        "OPEN24HOUR" => "$ 4,599",
        "HIGH24HOUR" => "$ 4,635.21",
        "LOW24HOUR" => "$ 4,500.55",
        "LASTMARKET" => "Coinbase",
        "CHANGE24HOUR" => "$ -10.63",
        "CHANGEPCT24HOUR" => "-0.23"
      }
    }.to_json
  end

  def basic_day_avg_json_response
    {
      "USD" => 4576.59,
      "ConversionType" => {
        "type" => "direct",
        "conversionSymbol" => ""
      }
    }.to_json
  end
end
