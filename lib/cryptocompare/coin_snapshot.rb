require 'faraday'
require 'json'

module Cryptocompare
  module CoinSnapshot
    API_URL = 'https://min-api.cryptocompare.com/data/top/exchanges/full'.freeze
    private_constant :API_URL

    # Get data for a currency pair. It returns general block explorer
    # information, aggregated data and individual data for each exchange
    # available.
    #
    # ==== Parameters
    #
    # * +from_sym+  [String]  - (required) currency symbol (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_sym+    [String]  - (required) currency symbol (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    #
    # ==== Returns
    #
    # [Hash] Hash with data about given currency pair.
    #
    # ==== Example
    #
    # Find data for a currency pair.
    #
    #   Cryptocompare::CoinSnapshot.find('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Message" => "Coin snapshot succesfully returned",
    #     "Type" => 100,
    #     "Data" => {
    #       "Algorithm" => "SHA256",
    #       "ProofType" => "PoW",
    #       "BlockNumber" => 378345,
    #       "NetHashesPerSecond" => 465548431.66333866,
    #       "TotalCoinsMined" => 14707625.0,
    #       "BlockReward" => 25.0,
    #       "AggregatedData" => {
    #         "TYPE" => "5",
    #         "MARKET" => "CCCAGG",
    #         "FROMSYMBOL" => "BTC",
    #         "TOSYMBOL" => "USD",
    #         "FLAGS" => "4",
    #         "PRICE" => "245.41",
    #         "LASTUPDATE" => "1444520460",
    #         "LASTVOLUME" => "0.0086",
    #         "LASTVOLUMETO" => "2.110268",
    #         "LASTTRADEID" => "1444520460357",
    #         "VOLUME24HOUR" => "49591.48108707269",
    #         "VOLUME24HOURTO" => "12139110.189163648",
    #         "OPEN24HOUR" => "244.41",
    #         "HIGH24HOUR" => "258.37",
    #         "LOW24HOUR" => "239.01000004",
    #         "LASTMARKET" => "Huobi"
    #       },
    #       "Exchanges" => [
    #         {
    #           "TYPE" => "2",
    #           "MARKET" => "LakeBTC",
    #           "FROMSYMBOL" => "BTC",
    #           "TOSYMBOL" => "USD",
    #           "FLAGS" => "2",
    #           "PRICE" => "244.37",
    #           "LASTUPDATE" => "1444513131",
    #           "LASTVOLUME" => "0.03",
    #           "LASTVOLUMETO" => "7.3311",
    #           "LASTTRADEID" => "1444513131",
    #           "VOLUME24HOUR" => "3599.0560000000005",
    #           "VOLUME24HOURTO" => "879237.6299349999",
    #           "OPEN24HOUR" => "243.83",
    #           "HIGH24HOUR" => "245.23",
    #           "LOW24HOUR" => "242.68"
    #         },
    #         ....
    #       ]
    #     }
    #   }
    def self.find(from_sym, to_sym)
      params = {
        'from_sym' => from_sym,
        'to_sym'   => to_sym
      }

      full_path = QueryParamHelper.set_query_params(API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
