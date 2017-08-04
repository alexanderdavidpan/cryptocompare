require 'test_helper'

class TestTopPairs < Minitest::Test
  TOP_PAIRS_KEYS = %w[
    exchange
    fromSymbol
    toSymbol
    volume24h
    volume24hTo
  ].freeze

  def test_find_top_pairs_for_given_currency
    VCR.use_cassette('eth_top_pairs') do
      resp = Cryptocompare::TopPairs.find('ETH')

      assert_equal 'Success', resp['Response']
      assert_kind_of Array, resp['Data']
      assert top_pairs = resp['Data']

      top_pairs.each do |top_pair|
        assert_equal 'ETH', top_pair['fromSymbol']

        TOP_PAIRS_KEYS.each do |top_pair_key|
          assert top_pair.has_key?(top_pair_key)
        end
      end
    end
  end

  def test_find_top_pairs_for_given_currency_limit_one
    VCR.use_cassette('eth_top_pairs_limit_one') do
      resp = Cryptocompare::TopPairs.find('ETH', {'limit' => 1})

      assert_equal 'Success', resp['Response']
      assert_kind_of Array, resp['Data']
      assert top_pairs = resp['Data']
      assert_equal 1, top_pairs.length

      top_pairs.each do |top_pair|
        assert_equal 'ETH', top_pair['fromSymbol']
        
        TOP_PAIRS_KEYS.each do |top_pair_key|
          assert top_pair.has_key?(top_pair_key)
        end
      end
    end
  end
end
