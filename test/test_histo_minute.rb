require 'test_helper'

class TestHistoMinute < Minitest::Test
  HISTORICAL_DATA_KEYS = %w[
    time
    close
    high
    low
    open
    volumefrom
    volumeto
  ].freeze

  def test_find_histo_minute_cryptocurrency_to_fiat
    VCR.use_cassette('btc_to_usd_histo_minute') do
      histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD')

      assert histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', histo_minute_resp['Response']

      histo_minute_data = histo_minute_resp['Data']
      assert histo_minute_data
      assert histo_minute_data.kind_of?(Array)

      histo_minute_data.each do |historical_data|
        HISTORICAL_DATA_KEYS.each do |histo_data_key|
          assert historical_data.has_key?(histo_data_key)
        end
      end
    end
  end

  def test_find_histo_minute_cryptocurrency_to_fiat_exchange_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&e=Poloneix')
      .to_return(:status => 200, :body => basic_histo_minute_json_response)

    Cryptocompare::HistoMinute.find('BTC', 'USD', {'e' => 'Poloneix'})
  end

  def test_find_histo_minute_cryptocurrency_to_fiat_limit_option
    # Limit 1 - Will return 2 data points
    VCR.use_cassette('btc_to_usd_histo_minute_with_limit_1') do
      histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD', {'limit' => 1})

      assert histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', histo_minute_resp['Response']

      histo_minute_data = histo_minute_resp['Data']
      assert histo_minute_data
      assert histo_minute_data.kind_of?(Array)
      assert_equal 2, histo_minute_data.length
    end

    # Limit 10 - Will return 11 data points
    VCR.use_cassette('btc_to_usd_histo_minute_with_limit_10') do
      histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD', {'limit' => 10})

      assert histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', histo_minute_resp['Response']

      histo_minute_data = histo_minute_resp['Data']
      assert histo_minute_data
      assert histo_minute_data.kind_of?(Array)
      assert_equal 11, histo_minute_data.length
    end
  end

  def test_find_histo_minute_cryptocurrency_to_fiat_agg_option
    # Unaggregated
    VCR.use_cassette('btc_to_usd_histo_minute_unaggregated') do
      unaggregated_histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD', {'agg' => 1})

      assert unaggregated_histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', unaggregated_histo_minute_resp['Response']

      refute unaggregated_histo_minute_resp['Aggregated']
    end

    # Aggregated
    VCR.use_cassette('btc_to_usd_histo_minute_aggregated') do
      unaggregated_histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD', {'agg' => 2})

      assert unaggregated_histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', unaggregated_histo_minute_resp['Response']

      assert unaggregated_histo_minute_resp['Aggregated']
    end
  end

  def test_find_histo_minute_cryptocurrency_to_fiat_to_ts_option
    VCR.use_cassette('btc_to_usd_histo_minute_with_to_ts') do
      to_timestamp = 1502515020

      histo_minute_resp = Cryptocompare::HistoMinute.find('BTC', 'USD', {'to_ts' => to_timestamp})

      assert histo_minute_resp.kind_of?(Hash)
      assert_equal 'Success', histo_minute_resp['Response']
      assert_equal to_timestamp, histo_minute_resp['TimeTo']

      histo_minute_data = histo_minute_resp['Data']
      assert histo_minute_data
      assert histo_minute_data.kind_of?(Array)

      assert_equal to_timestamp, histo_minute_data.last['time']
    end
  end

  def test_find_histo_minute_cryptocurrency_to_fiat_tc_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/histominute?fsym=BTC&tsym=USD&tryConversion=false')
      .to_return(:status => 200, :body => basic_histo_minute_json_response)

    Cryptocompare::HistoMinute.find('BTC', 'USD', {'tc' => false})
  end

  private

  def basic_histo_minute_json_response
    {
      "Response" => "Success",
      "Type" => 100,
      "Aggregated" => false,
      "Data" => []
    }.to_json
  end
end
