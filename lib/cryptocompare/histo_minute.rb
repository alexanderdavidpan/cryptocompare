require 'faraday'
require 'json'

module Cryptocompare
  module HistoMinute
    API_URL = 'https://min-api.cryptocompare.com/data/histominute'.freeze
    private_constant :API_URL

    # Get open, high, low, close, volumefrom and volumeto for each minute of
    # historical data. This data is only stored for 7 days, if you need more,
    # use the hourly or daily path. It uses BTC conversion if data is not
    # available because the coin is not trading in the specified currency.
    #
    # ==== Parameters
    #
    # * +from_sym+  [String]           - (required) currency symbol (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_syms+   [String, Array]    - (required) currency symbol(s)  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # * +opts+      [Hash]             - (optional) options hash
    #
    # ==== Options
    #
    # * +e+         [String]           - (optional) name of exchange (ex: 'Coinbase','Poloniex') Default: CCCAGG.
    # * +limit+     [Integer]          - (optional) limit. Default 1440. Max 2000. Must be positive integer. Returns limit + 1 data points.
    # * +agg+       [Integer]          - (optional) number of data points to aggregate. Default 1.
    # * +to_ts+     [Integer]          - (optional) timestamp. Use the timestamp option to set a historical start point. By default, it gets historical data for the past several minutes.
    # * +tc+        [Boolean]          - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    #
    # ==== Returns
    #
    # [Hash] Returns a hash containing data as an array of hashes containing
    #        info such as open, high, low, close, volumefrom and volumeto for
    #        each minute.
    #
    # ==== Examples
    #
    # Find historical data by minute for BTC to USD.
    #
    #   Cryptocompare::HistoMinute.find('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Type" => 100,
    #     "Aggregated" => true,
    #     "Data" => [
    #       {
    #         "time" => 1502259120,
    #         "close" => 3396.44,
    #         "high" => 3397.63,
    #         "low" => 3396.34,
    #         "open" => 3397.39,
    #         "volumefrom" => 98.2,
    #         "volumeto" => 335485
    #       },
    #       {
    #         "time" => 1502259300,
    #         "close" => 3396.86,
    #         "high" => 3396.94,
    #         "low" => 3396.44,
    #         "open" => 3396.44,
    #         "volumefrom" => 16.581031,
    #         "volumeto" => 56637.869999999995
    #       },
    #       ...
    #     ],
    #     "TimeTo" => 1502259360,
    #     "TimeFrom" => 1502259120,
    #     "FirstValueInArray" => true,
    #     "ConversionType" => {
    #       "type" => "direct",
    #       "conversionSymbol" => ""
    #     }
    #   }
    def self.find(from_sym, to_sym, opts = {})
      params = {
        'from_sym' => from_sym,
        'to_sym' => to_sym
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
