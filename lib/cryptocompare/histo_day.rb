require 'faraday'
require 'json'

module Cryptocompare
  module HistoDay
    API_URL = 'https://min-api.cryptocompare.com/data/histoday'.freeze
    private_constant :API_URL

    # Get open, high, low, close, volumefrom and volumeto daily historical data.
    # The values are based on 00:00 GMT time. It uses BTC conversion if data is
    # not available because the coin is not trading in the specified currency.
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
    # * +limit+     [Integer]          - (optional) limit. Default 30. Max 2000. Must be positive integer. Returns limit + 1 data points.
    # * +agg+       [Integer]          - (optional) number of data points to aggregate. Default 1.
    # * +to_ts+     [Integer]          - (optional) timestamp. Use the timestamp option to set a historical start point. By default, it gets historical data for the past several days.
    # * +tc+        [Boolean]          - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    # * +all_data+  [Boolean]          - (optional) all data. Default false. Returns all available data instead of limit.
    #
    # ==== Returns
    #
    # [Hash] Returns a hash containing data as an array of hashes containing
    #        info such as open, high, low, close, volumefrom and volumeto for
    #        each day.
    #
    # ==== Examples
    #
    #   Cryptocompare::HistoDay.find('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Type" => 100,
    #     "Aggregated" => false,
    #     "Data" => [
    #       {
    #         "time" => 1500854400,
    #         "close" => 2763.42,
    #         "high" => 2798.89,
    #         "low" => 2715.69,
    #         "open" => 2756.61,
    #         "volumefrom" => 83009.25,
    #         "volumeto" => 229047365.02
    #       },
    #       {
    #         "time" => 1500940800,
    #         "close" => 2582.58,
    #         "high" => 2779.08,
    #         "low" => 2472.62,
    #         "open" => 2763.42,
    #         "volumefrom" => 205883.15,
    #         "volumeto" => 534765380.75
    #       },
    #       ...
    #     ],
    #     "TimeTo" => 1503446400,
    #     "TimeFrom" => 1500854400,
    #     "FirstValueInArray" => true,
    #     "ConversionType" => {
    #       "type" => "direct",
    #       "conversionSymbol" => ""
    #     }
    #   }
    def self.find(from_sym, to_sym, opts = {})
      params = {
        'from_sym' => from_sym,
        'to_sym'   => to_sym
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
