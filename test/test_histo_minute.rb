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
end
