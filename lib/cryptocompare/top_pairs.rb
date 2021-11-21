require 'faraday'
require 'json'

module Cryptocompare
  module TopPairs
    API_URL = 'https://min-api.cryptocompare.com/data/top/pairs'.freeze
    private_constant :API_URL

    # Get top pairs by volume for a currency (always uses aggregated data).
    # The number of pairs you get is the minimum of the limit you set
    # (default 5) and the total number of pairs available.
    #
    # ==== Parameters
    #
    # * +from_sym+  [String]           - (required) currency symbol (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +opts+      [Hash]             - (optional) options hash
    #
    # ==== Options
    #
    # * +limit+     [Integer]          - (optional) limit. Default 5. Max 2000.
    #
    # ==== Returns
    #
    # [Hash] Returns a hash containing data as an array of hashes containing
    #        info about top-traded pairs.
    #
    # ==== Examples
    #
    # Find top pairs by trading volume for a given currency.
    #
    #   Cryptocompare::TopPairs.find('ETH')
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Data" => [
    #       {
    #         "exchange" => "CCCAGG",
    #         "fromSymbol" => "ETH",
    #         "toSymbol" => "USD",
    #         "volume24h" => 1310705.3005027298,
    #         "volume24hTo" => 288031723.3503975
    #       },
    #       {
    #         "exchange" => "CCCAGG",
    #         "fromSymbol" => "ETH",
    #         "toSymbol" => "BTC",
    #         "volume24h" => 978200.2198323006,
    #         "volume24hTo" => 77883.06190085363
    #       },
    #       ...
    #     ]
    #   }
    def self.find(from_sym, opts = {})
      params = {
        'from_sym' => from_sym
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
