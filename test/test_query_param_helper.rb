require 'test_helper'

class TestQueryParamHelper < Minitest::Test
  def test_set_query_params
    api_url = 'https://min-api.cryptocompare.com'

    params = {
      'agg'       => 10,
      'all_data'  => true,
      'e'         => 'COINBASE',
      'from_sym'  => 'BTC',
      'from_syms' => 'BTC,ETH',
      'limit'     => 10,
      'tc'        => false,
      'to_sym'    => 'USD',
      'to_syms'   => 'USD,EUR',
      'to_ts'     => 1452680400,
      'ts'        => 1452680400
    }

    expected_path = "https://min-api.cryptocompare.com?aggregate=10" \
    "&allData=true&e=COINBASE&fsym=BTC&fsyms=BTC,ETH&limit=10&toTs=1452680400" \
    "&tryConversion=false&ts=1452680400&tsym=USD&tsyms=USD,EUR"

    assert_equal expected_path, Cryptocompare::QueryParamHelper.set_query_params(api_url, params)
  end
end
