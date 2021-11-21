require 'faraday'
require 'json'

module Cryptocompare
  module HistoHour
    API_URL = 'https://min-api.cryptocompare.com/data/histohour'.freeze
    private_constant :API_URL

    # Get open, high, low, close, volumefrom and volumeto from the each hour
    # historical data. It uses BTC conversion if data is not available because
    # the coin is not trading in the specified currency.
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
    # * +limit+     [Integer]          - (optional) limit. Default 168. Max 2000. Must be positive integer. Returns limit + 1 data points.
    # * +agg+       [Integer]          - (optional) number of data points to aggregate. Default 1.
    # * +to_ts+     [Integer]          - (optional) timestamp. Use the timestamp option to set a historical start point. By default, it gets historical data for the past several hours.
    # * +tc+        [Boolean]          - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    #
    # ==== Returns
    #
    # [Hash] Returns a hash containing data as an array of hashes containing
    #        info such as open, high, low, close, volumefrom and volumeto for
    #        each hour.
    #
    # ==== Examples
    #
    #   Cryptocompare::HistoHour.find('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Type" => 100,
    #     "Aggregated" => false,
    #     "Data" => [
    #       {
    #         "time" => 1502643600,
    #         "close" => 3998.47,
    #         "high" => 4069.8,
    #         "low" => 3982.5,
    #         "open" => 4059.28,
    #         "volumefrom" => 5087.23,
    #         "volumeto" => 20453919.02
    #       },
    #       {
    #         "time" => 1502647200,
    #         "close" => 4061.5,
    #         "high" => 4074.57,
    #         "low" => 3998.47,
    #         "open" => 3998.47,
    #         "volumefrom" => 3839.78,
    #         "volumeto" => 15606476.19
    #       },
    #       ...
    #     ],
    #     "TimeTo" => 1503248400,
    #     "TimeFrom" => 1502643600,
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
