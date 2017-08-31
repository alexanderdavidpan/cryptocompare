require 'faraday'
require 'json'

module Cryptocompare
  module Price
    PRICE_API_URL = 'https://min-api.cryptocompare.com/data/pricemulti'
    GENERATE_AVG_API_URL = 'https://min-api.cryptocompare.com/data/generateAvg'

    # Finds the currency price(s) of a given currency symbol. Really fast,
    # 20-60 ms. Cached each 10 seconds.
    #
    # ==== Parameters
    #
    # * +from_syms+ [String, Array] - (required) currency symbols  (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_syms+   [String, Array] - (required) currency symbols  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # * +opts+      [Hash]          - (optional) options hash
    #
    # ==== Options
    #
    # * +e+         [String]        - (optional) name of exchange (ex: 'Coinbase','Poloniex') Default: CCCAGG.
    #
    # ==== Returns
    #
    # [Hash] Hash with currency prices
    #
    # ==== Examples
    #
    # Convert cryptocurrency to fiat.
    #
    #   Cryptocompare::Price.find('BTC', 'USD')
    #   #=> {"BTC"=>{"USD"=>2594.07}}
    #
    # Convert fiat to cryptocurrency.
    #
    #   Cryptocompare::Price.find('USD', 'BTC')
    #   #=> {"USD"=>{"BTC"=>0.0004176}}
    #
    # Convert cryptocurrency to cryptocurrency.
    #
    #   Cryptocompare::Price.find('BTC', 'ETH')
    #   #=> {"BTC"=>{"ETH"=>9.29}}
    #
    # Convert fiat to fiat.
    #
    #   Cryptocompare::Price.find('USD', 'EUR')
    #   #=> {"USD"=>{"EUR"=>0.8772}}
    #
    # Convert multiple cryptocurrencies to multiple fiat.
    #
    #   Cryptocompare::Price.find(['BTC','ETH', 'LTC'], ['USD', 'EUR', 'CNY'])
    #   #=> {"BTC"=>{"USD"=>2501.61, "EUR"=>2197.04, "CNY"=>17329.48}, "ETH"=>{"USD"=>236.59, "EUR"=>209.39, "CNY"=>1655.15}, "LTC"=>{"USD"=>45.74, "EUR"=>40.33, "CNY"=>310.5}}
    #
    # Convert multiple fiat to multiple cryptocurrencies.
    #
    #   Cryptocompare::Price.find(['USD', 'EUR'], ['BTC','ETH', 'LTC'])
    #   #=> {"USD"=>{"BTC"=>0.0003996, "ETH"=>0.004238, "LTC"=>0.02184}, "EUR"=>{"BTC"=>0.0004548, "ETH"=>0.00477, "LTC"=>0.0248}}
    #
    # Find prices based on exchange.
    #
    #   Cryptocompare::Price.find('DASH', 'USD', {'e' => 'Kraken'})
    #   #=> {"DASH"=>{"USD"=>152.4}}
    def self.find(from_syms, to_syms, opts = {})
      params = {
        'from_syms' => Array(from_syms).join(','),
        'to_syms'   => Array(to_syms).join(',')
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(PRICE_API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end

    # Compute the current trading info (price, vol, open, high, low, etc) of the
    # requested pair as a volume weighted average based on the markets that are
    # requested.
    #
    # ==== Parameters
    #
    # * +from_sym+  [String]        - (required) currency symbols  (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_sym+    [String]        - (required) currency symbols  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # * +markets+   [String, Array] - (required) Name of exchanges. Supports multiple. (ex: 'Coinbase','Poloniex')
    # * +opts+      [Hash]          - (optional) options hash
    #
    # ==== Options
    #
    # * +tc+        [Boolean]       - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    #
    # ==== Returns
    #
    # [Hash] Hash that returns two hashes: raw and display. Both contain similar
    #        data, one is just raw data and the other is meant for displaying.
    #        See sample response below for data that is returned.
    #
    # ==== Examples
    #
    # Generate average price for cryptocurrency to fiat currency.
    #
    #   Cryptocompare::Price.generate_avg('BTC', 'USD', ['Coinbase', 'Bitfinex'])
    #
    # Sample response
    #
    #   {
    #     RAW: {
    #       MARKET: "CUSTOMAGG",
    #       FROMSYMBOL: "BTC",
    #       TOSYMBOL: "USD",
    #       FLAGS: 0,
    #       PRICE: 4137.43,
    #       LASTUPDATE: 1503454563,
    #       LASTVOLUME: 2,
    #       LASTVOLUMETO: 8271.98,
    #       LASTTRADEID: 19656029,
    #       VOLUME24HOUR: 71728.71957884016,
    #       VOLUME24HOURTO: 279374718.3442189,
    #       OPEN24HOUR: 3885.85,
    #       HIGH24HOUR: 4145,
    #       LOW24HOUR: 3583.46,
    #       LASTMARKET: "Coinbase",
    #       CHANGE24HOUR: 251.58000000000038,
    #       CHANGEPCT24HOUR: 6.474259171095137
    #     },
    #     DISPLAY: {
    #       FROMSYMBOL: "Ƀ",
    #       TOSYMBOL: "$",
    #       MARKET: "CUSTOMAGG",
    #       PRICE: "$ 4,137.43",
    #       LASTUPDATE: "Just now",
    #       LASTVOLUME: "Ƀ 2",
    #       LASTVOLUMETO: "$ 8,271.98",
    #       LASTTRADEID: 19656029,
    #       VOLUME24HOUR: "Ƀ 71,728.7",
    #       VOLUME24HOURTO: "$ 279,374,718.3",
    #       OPEN24HOUR: "$ 3,885.85",
    #       HIGH24HOUR: "$ 4,145",
    #       LOW24HOUR: "$ 3,583.46",
    #       LASTMARKET: "Coinbase",
    #       CHANGE24HOUR: "$ 251.58",
    #       CHANGEPCT24HOUR: "6.47"
    #     }
    #   }
    def self.generate_avg(from_sym, to_sym, markets, opts = {})
      params = {
        'from_sym' => from_sym,
        'to_sym'   => to_sym,
        'markets'  => Array(markets).join(',')
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(GENERATE_AVG_API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
