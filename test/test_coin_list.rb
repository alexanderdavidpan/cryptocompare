require 'test_helper'

class TestCoinList < Minitest::Test
  COINLIST_TOP_LEVEL_RESPONSE_KEYS = %w[
    Response
    Message
    BaseImageUrl
    BaseLinkUrl
    DefaultWatchlist
    Data
    Type
  ].freeze

  COIN_DATA_KEYS = %w[
    Id
    Url
    Name
    Symbol
    CoinName
    FullName
    Algorithm
    ProofType
    FullyPremined
    TotalCoinSupply
    PreMinedValue
    TotalCoinsFreeFloat
    SortOrder
    Sponsored
  ].freeze

  def test_find_all_coins
    VCR.use_cassette('coin_list') do
      resp = Cryptocompare::CoinList.all

      COINLIST_TOP_LEVEL_RESPONSE_KEYS.each do |data_key|
        assert resp.has_key?(data_key)
      end

      resp['Data'].each do |coin, coin_data|
        COIN_DATA_KEYS.each do |data_key|
          assert coin_data.has_key?(data_key)
        end
      end
    end
  end
end
