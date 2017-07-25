require 'faraday'
require 'json'
require 'yaml'

module Cryptocompare
  EXCHANGES = YAML::load_file(File.join(__dir__, '../../config/exchanges.yml'))

  module Price
    API_URL = 'https://min-api.cryptocompare.com/data/pricemulti'

    # Finds the currency price(s) of a given currency symbol. Really fast,
    # 20-60 ms. Cached each 10 seconds.
    #
    # Params:
    # from_syms [String, Array] - currency symbols  (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # to_syms   [String, Array] - currency symbols  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # opts      [Hash]          - options hash
    # opts[e]   [String]        - name of exchange (ex: 'Coinbase','Poloniex') Default: CCCAGG.
    #
    # Returns:
    # [Hash] Hash with currency prices
    #
    # Examples:
    #
    # Convert cryptocurrency to fiat.
    #
    #   Cryptocompare::Price.find('BTC', 'USD') #=> {"BTC"=>{"USD"=>2594.07}}
    #
    # Convert fiat to cryptocurrency.
    #
    #   Cryptocompare::Price.find('USD', 'BTC') #=> {"USD"=>{"BTC"=>0.0004176}}
    #
    # Convert cryptocurrency to cryptocurrency.
    #
    #   Cryptocompare::Price.find('BTC', 'ETH') #=>{"BTC"=>{"ETH"=>9.29}}
    #
    # Convert fiat to fiat.
    #
    #   Cryptocompare::Price.find('USD', 'EUR') #=> {"USD"=>{"EUR"=>0.8772}}
    #
    # Convert multiple cryptocurrencies to multiple fiat.
    #
    #   Cryptocompare::Price.find(['BTC','ETH', 'LTC'], ['USD', 'EUR', 'CNY']) #=> {"BTC"=>{"USD"=>2501.61, "EUR"=>2197.04, "CNY"=>17329.48}, "ETH"=>{"USD"=>236.59, "EUR"=>209.39, "CNY"=>1655.15}, "LTC"=>{"USD"=>45.74, "EUR"=>40.33, "CNY"=>310.5}}
    #
    # Convert multiple fiat to multiple cryptocurrencies.
    #
    #   Cryptocompare::Price.find(['USD', 'EUR'], ['BTC','ETH', 'LTC']) #=> {"USD"=>{"BTC"=>0.0003996, "ETH"=>0.004238, "LTC"=>0.02184}, "EUR"=>{"BTC"=>0.0004548, "ETH"=>0.00477, "LTC"=>0.0248}}
    #
    # Find prices based on exchange.
    #
    #   Cryptocompare::Price.find('DASH', 'USD', {'e' => 'Kraken'}) #=> {"DASH"=>{"USD"=>152.4}}
    def self.find(from_syms, to_syms, opts = {})
      fsyms = Array(from_syms).join(',')
      tsyms = Array(to_syms).join(',')
      full_path = API_URL + "?fsyms=#{fsyms}&tsyms=#{tsyms}"
      full_path += "&e=#{set_exchange(opts['e'])}" if opts['e']
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end

    private

    # Helper method to overcome case-sensitive exchange name enforced by the API.
    # If no supported exchange mapping is found, it will try user's input.
    def self.set_exchange(exchange)
      EXCHANGES[exchange.upcase] || exchange
    end
  end
end
