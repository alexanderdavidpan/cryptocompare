require 'test_helper'

class TestCoinSnapshot < Minitest::Test
  CRYPTOCURRENCY_DATA_KEYS = %w[
    Algorithm
    ProofType
    BlockNumber
    NetHashesPerSecond
    TotalCoinsMined
    BlockReward
    AggregatedData
    Exchanges
  ].freeze

  FIAT_DATA_KEYS = %w[
    AggregatedData
    Exchanges
  ].freeze

  AGGREGATED_DATA_KEYS = %w[
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
  ].freeze

  EXCHANGE_KEYS = %w[
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
  ].freeze

  def test_find_coin_snapshot_cryptocurrency_to_fiat
    VCR.use_cassette('btc_to_usd_coin_snapshot') do
      resp = Cryptocompare::CoinSnapshot.find('BTC', 'USD')

      assert_equal 'Success', resp['Response']
      assert_equal 'Coin snapshot succesfully returned', resp['Message']

      CRYPTOCURRENCY_DATA_KEYS.each do |data_key|
        assert resp['Data'].has_key?(data_key)
      end

      AGGREGATED_DATA_KEYS.each do |agg_data_key|
        assert resp['Data']['AggregatedData'].has_key?(agg_data_key)
      end

      resp['Data']['Exchanges'].each do |exchange|
        EXCHANGE_KEYS.each do |exchange_key|
          assert exchange.has_key?(exchange_key)
        end
      end
    end
  end

  def test_find_coin_snapshot_cryptocurrency_to_cryptocurrency
    VCR.use_cassette('eth_to_btc_coin_snapshot') do
      resp = Cryptocompare::CoinSnapshot.find('ETH', 'BTC')

      assert_equal 'Success', resp['Response']
      assert_equal 'Coin snapshot succesfully returned', resp['Message']

      CRYPTOCURRENCY_DATA_KEYS.each do |data_key|
        assert resp['Data'].has_key?(data_key)
      end

      AGGREGATED_DATA_KEYS.each do |agg_data_key|
        assert resp['Data']['AggregatedData'].has_key?(agg_data_key)
      end

      resp['Data']['Exchanges'].each do |exchange|
        EXCHANGE_KEYS.each do |exchange_key|
          assert exchange.has_key?(exchange_key)
        end
      end
    end
  end

  def test_find_coin_snapshot_fiat_to_cryptocurrency
    VCR.use_cassette('usd_to_eth_coin_snapshot') do
      resp = Cryptocompare::CoinSnapshot.find('USD', 'ETH')

      assert_equal 'Success', resp['Response']
      assert_equal 'Coin snapshot succesfully returned', resp['Message']

      FIAT_DATA_KEYS.each do |data_key|
        assert resp['Data'].has_key?(data_key)
      end

      AGGREGATED_DATA_KEYS.each do |agg_data_key|
        assert resp['Data']['AggregatedData'].has_key?(agg_data_key)
      end

      resp['Data']['Exchanges'].each do |exchange|
        EXCHANGE_KEYS.each do |exchange_key|
          assert exchange.has_key?(exchange_key)
        end
      end
    end
  end

  def test_find_coin_snapshot_fiat_to_fiat
    VCR.use_cassette('eur_to_usd_coin_snapshot') do
      resp = Cryptocompare::CoinSnapshot.find('EUR', 'USD')

      assert_equal 'Success', resp['Response']
      assert_equal 'Coin snapshot succesfully returned', resp['Message']

      FIAT_DATA_KEYS.each do |data_key|
        assert resp['Data'].has_key?(data_key)
      end

      AGGREGATED_DATA_KEYS.each do |agg_data_key|
        assert resp['Data']['AggregatedData'].has_key?(agg_data_key)
      end

      resp['Data']['Exchanges'].each do |exchange|
        EXCHANGE_KEYS.each do |exchange_key|
          assert exchange.has_key?(exchange_key)
        end
      end
    end
  end
end
