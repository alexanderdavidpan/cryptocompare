require 'faraday'
require 'json'

module Cryptocompare
  module Price
    PRICE_API_URL = 'https://min-api.cryptocompare.com/data/pricemulti'.freeze
    private_constant :PRICE_API_URL

    PRICE_FULL_API_URL = 'https://min-api.cryptocompare.com/data/pricemultifull'.freeze
    private_constant :PRICE_FULL_API_URL

    GENERATE_AVG_API_URL = 'https://min-api.cryptocompare.com/data/generateAvg'.freeze
    private_constant :GENERATE_AVG_API_URL

    DAY_AVG_API_URL = 'https://min-api.cryptocompare.com/data/dayAvg'.freeze
    private_constant :DAY_AVG_API_URL

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

    # Get all the current trading info (price, vol, open, high, low etc) of any
    # list of cryptocurrencies in any other currency that you need. If the
    # crypto does not trade directly into the toSymbol requested, BTC will be
    # used for conversion. This API also returns display values for all the
    # fields. If the opposite pair trades we invert it (eg.: BTC-XMR).
    #
    # ==== Parameters
    #
    # * +from_sym+  [String, Array]     - (required) currency symbols (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_sym+    [String, Array]     - (required) currency symbols (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # * +opts+      [Hash]              - (optional) options hash
    #
    # ==== Options
    #
    # * +e+         [String]            - (optional) name of exchange (ex: 'Coinbase','Poloniex') Default: CCCAGG.
    # * +tc+        [Boolean]           - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    #
    # ==== Returns
    #
    # [Hash] Hash that returns two hashes: RAW and DISPLAY. Both contain similar
    #        data, one is just raw data and the other is meant for displaying.
    #        See sample response below for data that is returned.
    #
    # ==== Examples
    #
    # Get full price info (raw and display) for cryptocurrency to fiat currency.
    #
    #   Cryptocompare::Price.full('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "RAW" => {
    #       "BTC" => {
    #         "USD" => {
    #           "TYPE"=>"5",
    #           "MARKET"=>"CCCAGG",
    #           "FROMSYMBOL"=>"BTC",
    #           "TOSYMBOL"=>"USD",
    #           "FLAGS"=>"4",
    #           "PRICE"=>4551.84,
    #           "LASTUPDATE"=>1504753702,
    #           "LASTVOLUME"=>2.19e-06,
    #           "LASTVOLUMETO"=>0.00995355,
    #           "LASTTRADEID"=>20466080,
    #           "VOLUME24HOUR"=>110449.85666195827,
    #           "VOLUME24HOURTO"=>503369392.8440719,
    #           "OPEN24HOUR"=>4497.45,
    #           "HIGH24HOUR"=>4667.51,
    #           "LOW24HOUR"=>4386.51,
    #           "LASTMARKET"=>"Coinbase",
    #           "CHANGE24HOUR"=>54.39000000000033,
    #           "CHANGEPCT24HOUR"=>1.2093519661141388,
    #           "SUPPLY"=>16549137,
    #           "MKTCAP"=>75329023762.08
    #         }
    #       }
    #     },
    #     "DISPLAY" => {
    #       "BTC" => {
    #         "USD" => {
    #           "FROMSYMBOL"=>"Ƀ",
    #           "TOSYMBOL"=>"$",
    #           "MARKET"=>"CryptoCompare Index",
    #           "PRICE"=>"$ 4,551.84",
    #           "LASTUPDATE"=>"Just now",
    #           "LASTVOLUME"=>"Ƀ 0.00000219",
    #           "LASTVOLUMETO"=>"$ 0.009954",
    #           "LASTTRADEID"=>20466080,
    #           "VOLUME24HOUR"=>"Ƀ 110,449.9",
    #           "VOLUME24HOURTO"=>"$ 503,369,392.8",
    #           "OPEN24HOUR"=>"$ 4,497.45",
    #           "HIGH24HOUR"=>"$ 4,667.51",
    #           "LOW24HOUR"=>"$ 4,386.51",
    #           "LASTMARKET"=>"Coinbase",
    #           "CHANGE24HOUR"=>"$ 54.39",
    #           "CHANGEPCT24HOUR"=>"1.21",
    #           "SUPPLY"=>"Ƀ 16,549,137",
    #           "MKTCAP"=>"$ 75.33 B"
    #         }
    #       }
    #     }
    #   }
    def self.full(from_syms, to_syms, opts = {})
      params = {
        'from_syms' => Array(from_syms).join(','),
        'to_syms'   => Array(to_syms).join(','),
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(PRICE_FULL_API_URL, params)
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
    # * +e+         [String, Array] - (required) Name of exchanges. Supports multiple. (ex: 'Coinbase','Poloniex')
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
    #     "RAW" => {
    #       "MARKET" => "CUSTOMAGG",
    #       "FROMSYMBOL" => "BTC",
    #       "TOSYMBOL" => "USD",
    #       "FLAGS" => 0,
    #       "PRICE" => 4137.43,
    #       "LASTUPDATE" => 1503454563,
    #       "LASTVOLUME" => 2,
    #       "LASTVOLUMETO" => 8271.98,
    #       "LASTTRADEID" => 19656029,
    #       "VOLUME24HOUR" => 71728.71957884016,
    #       "VOLUME24HOURTO" => 279374718.3442189,
    #       "OPEN24HOUR" => 3885.85,
    #       "HIGH24HOUR" => 4145,
    #       "LOW24HOUR" => 3583.46,
    #       "LASTMARKET" => "Coinbase",
    #       "CHANGE24HOUR" => 251.58000000000038,
    #       "CHANGEPCT24HOUR" => 6.474259171095137
    #     },
    #     "DISPLAY" => {
    #       "FROMSYMBOL" => "Ƀ",
    #       "TOSYMBOL" => "$",
    #       "MARKET" => "CUSTOMAGG",
    #       "PRICE" => "$ 4,137.43",
    #       "LASTUPDATE" => "Just now",
    #       "LASTVOLUME" => "Ƀ 2",
    #       "LASTVOLUMETO" => "$ 8,271.98",
    #       "LASTTRADEID" => 19656029,
    #       "VOLUME24HOUR" => "Ƀ 71,728.7",
    #       "VOLUME24HOURTO" => "$ 279,374,718.3",
    #       "OPEN24HOUR" => "$ 3,885.85",
    #       "HIGH24HOUR" => "$ 4,145",
    #       "LOW24HOUR" => "$ 3,583.46",
    #       "LASTMARKET" => "Coinbase",
    #       "CHANGE24HOUR" => "$ 251.58",
    #       "CHANGEPCT24HOUR" => "6.47"
    #     }
    #   }
    def self.generate_avg(from_sym, to_sym, e, opts = {})
      params = {
        'from_sym' => from_sym,
        'to_sym'   => to_sym,
        'e'        => Array(e).join(',')
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(GENERATE_AVG_API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end

    # Get day average price. The values are based on hourly vwap data and the
    # average can be calculated in different ways. It uses BTC conversion if
    # data is not available because the coin is not trading in the specified
    # currency. If 'tc' param is set to false, it will give you the direct
    # data. If no toTS is given it will automatically do the current day. Also,
    # for different timezones use the utc_offset param. The calculation types
    # are: HourVWAP - a VWAP of the hourly close price,MidHighLow - the average
    # between the 24 H high and low.VolFVolT - the total volume from / the total
    # volume to (only avilable with tryConversion set to false so only for
    # direct trades but the value should be the most accurate price)
    #
    # ==== Parameters
    #
    # * +from_sym+    [String]        - (required) currency symbols  (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # * +to_sym+      [String]        - (required) currency symbols  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # * +opts+        [Hash]          - (optional) options hash
    #
    # ==== Options
    #
    # * +e+           [String]        - (optional) name of exchange (ex: 'Coinbase','Poloniex') Default: CCCAGG.
    # * +tc+          [Boolean]       - (optional) try conversion. Default true. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
    # * +to_ts+       [Integer]       - (optional) timestamp. Must be an hour unit.
    # * +utc_offset+  [Integer]       - (optional) Default is UTC, but if you want a different time zone just pass the hour difference. For example, for PST you would pass -8.
    #
    # ==== Returns
    #
    # [Hash] Hash with currency prices and information about conversion type.
    #
    # ==== Examples
    #
    # Generate average day price for cryptocurrency to fiat currency.
    #
    #   Cryptocompare::Price.day_avg('BTC', 'USD')
    #
    # Sample response
    #
    #   {
    #     "USD" => 4109.92,
    #     "ConversionType" => {
    #       "type" => "direct",
    #       "conversionSymbol" => ""
    #     }
    #   }
    def self.day_avg(from_sym, to_sym, opts = {})
      params = {
        'from_sym' => from_sym,
        'to_sym'   => to_sym,
      }.merge!(opts)

      full_path = QueryParamHelper.set_query_params(DAY_AVG_API_URL, params)
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
