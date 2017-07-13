require 'faraday'
require 'json'

module Cryptocompare
  API_URL = 'https://min-api.cryptocompare.com/data/pricemulti'

  module Price
    # Finds the currency price(s) of a given currency symbol
    #
    # Params:
    # from_syms [String, Array] - currency symbols  (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # to_syms   [String, Array] - currency symbols  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    #
    # Returns:
    # [Hash] Hash with currency prices
    #
    # Examples:
    # 1. Cryptocurrency to Fiat
    #
    # Cryptocompare::Price.find('BTC', 'USD')
    # => {"BTC"=>{"USD"=>2594.07}}
    #
    # 2. Fiat to Cryptocurrency
    #
    #  Cryptocompare::Price.find('USD', 'BTC')
    # => {"USD"=>{"BTC"=>0.0004176}}
    #
    # 3. Cryptocurrency to Cryptocurrency
    #
    # Cryptocompare::Price.find('BTC', 'ETH')
    # =>{"BTC"=>{"ETH"=>9.29}}
    #
    # 4. Fiat to Fiat
    # Cryptocompare::Price.find('USD', 'EUR')
    # => {"USD"=>{"EUR"=>0.8772}}
    #
    # 5. Multiple cryptocurrencies to multiple fiat
    # Cryptocompare::Price.find(['BTC','ETH', 'LTC'], ['USD', 'EUR', 'CNY'])
    # => {"BTC"=>{"USD"=>2501.61, "EUR"=>2197.04, "CNY"=>17329.48}, "ETH"=>{"USD"=>236.59, "EUR"=>209.39, "CNY"=>1655.15}, "LTC"=>{"USD"=>45.74, "EUR"=>40.33, "CNY"=>310.5}}
    #
    # 6. Multiple fiat to multiple cryptocurrencies
    # Cryptocompare::Price.find(['USD', 'EUR'], ['BTC','ETH', 'LTC'])
    # => {"USD"=>{"BTC"=>0.0003996, "ETH"=>0.004238, "LTC"=>0.02184}, "EUR"=>{"BTC"=>0.0004548, "ETH"=>0.00477, "LTC"=>0.0248}}
    def self.find(from_syms, to_syms)
      fsyms = Array(from_syms).join(',')
      tsyms = Array(to_syms).join(',')
      full_path = API_URL + "?fsyms=#{fsyms}&tsyms=#{tsyms}"
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
