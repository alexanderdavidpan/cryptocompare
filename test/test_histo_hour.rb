require 'test_helper'

class TestHistoHour < Minitest::Test
  HISTORICAL_DATA_KEYS = %w[
    time
    close
    high
    low
    open
    volumefrom
    volumeto
  ].freeze

  def test_find_histo_hour_cryptocurrency_to_fiat
    VCR.use_cassette('btc_to_usd_histo_hour') do
      histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD')

      assert histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', histo_hour_resp['Response']

      histo_hour_data = histo_hour_resp['Data']
      assert histo_hour_data
      assert histo_hour_data.kind_of?(Array)

      histo_hour_data.each do |historical_data|
        HISTORICAL_DATA_KEYS.each do |histo_data_key|
          assert historical_data.has_key?(histo_data_key)
        end
      end
    end
  end

  def test_find_histo_hour_cryptocurrency_to_fiat_exchange_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&e=Poloneix')
      .to_return(:status => 200, :body => basic_histo_hour_json_response)

    Cryptocompare::HistoHour.find('BTC', 'USD', {'e' => 'Poloneix'})
  end

  def test_find_histo_hour_cryptocurrency_to_fiat_limit_option
    # Limit 1 - Will return 2 data points
    VCR.use_cassette('btc_to_usd_histo_hour_with_limit_1') do
      histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD', {'limit' => 1})

      assert histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', histo_hour_resp['Response']

      histo_hour_data = histo_hour_resp['Data']
      assert histo_hour_data
      assert histo_hour_data.kind_of?(Array)
      assert_equal 2, histo_hour_data.length
    end

    # Limit 10 - Will return 11 data points
    VCR.use_cassette('btc_to_usd_histo_hour_with_limit_10') do
      histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD', {'limit' => 10})

      assert histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', histo_hour_resp['Response']

      histo_hour_data = histo_hour_resp['Data']
      assert histo_hour_data
      assert histo_hour_data.kind_of?(Array)
      assert_equal 11, histo_hour_data.length
    end
  end

  def test_find_histo_hour_cryptocurrency_to_fiat_agg_option
    # Unaggregated
    VCR.use_cassette('btc_to_usd_histo_hour_unaggregated') do
      unaggregated_histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD', {'agg' => 1})

      assert unaggregated_histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', unaggregated_histo_hour_resp['Response']

      refute unaggregated_histo_hour_resp['Aggregated']
    end

    # Aggregated
    VCR.use_cassette('btc_to_usd_histo_hour_aggregated') do
      unaggregated_histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD', {'agg' => 2})

      assert unaggregated_histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', unaggregated_histo_hour_resp['Response']

      assert unaggregated_histo_hour_resp['Aggregated']
    end
  end

  def test_find_histo_hour_cryptocurrency_to_fiat_to_ts_option
    VCR.use_cassette('btc_to_usd_histo_hour_with_to_ts') do
      to_timestamp = 1502514000

      histo_hour_resp = Cryptocompare::HistoHour.find('BTC', 'USD', {'to_ts' => to_timestamp})

      assert histo_hour_resp.kind_of?(Hash)
      assert_equal 'Success', histo_hour_resp['Response']
      assert_equal to_timestamp, histo_hour_resp['TimeTo']

      histo_hour_data = histo_hour_resp['Data']
      assert histo_hour_data
      assert histo_hour_data.kind_of?(Array)

      assert_equal to_timestamp, histo_hour_data.last['time']
    end
  end

  def test_find_histo_hour_cryptocurrency_to_fiat_tc_option
    stub_request(:get, 'https://min-api.cryptocompare.com/data/histohour?fsym=BTC&tsym=USD&tryConversion=false')
      .to_return(:status => 200, :body => basic_histo_hour_json_response)

    Cryptocompare::HistoHour.find('BTC', 'USD', {'tc' => false})
  end

  private

  def basic_histo_hour_json_response
    {
      "Response" => "Success",
      "Type" => 100,
      "Aggregated" => false,
      "Data" => []
    }.to_json
  end
end
