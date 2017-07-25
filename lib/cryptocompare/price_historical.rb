require 'faraday'
require 'json'
require 'yaml'

module Cryptocompare
  module PriceHistorical
    API_URL = 'https://min-api.cryptocompare.com/data/pricehistorical'

    # Finds the price of any cryptocurrency in any other currency that you need
    # at a given timestamp. The price comes from the daily info - so it would be
    # the price at the end of the day GMT based on the requested timestamp.  If
    # the crypto does not trade directly into the toSymbol requested, BTC will
    # be used for conversion. Tries to get direct trading pair data, if there is
    # none or it is more than 30 days before the ts requested, it uses BTC
    # conversion. If the opposite pair trades we invert it (eg.: BTC-XMR)
    #
    # Params:
    # from_sym  [String]           - (required) currency symbol (ex: 'BTC', 'ETH', 'LTC', 'USD', 'EUR', 'CNY')
    # to_syms   [String, Array]    - (required) currency symbol(s)  (ex: 'USD', 'EUR', 'CNY', 'USD', 'EUR', 'CNY')
    # opts      [Hash]             - (optional) options hash
    # opts[ts]  [String, Integer]  - (optional) timestamp
    #
    # Returns:
    # [Hash] Hash with currency prices
    #
    # Examples:
    #
    # Find historical price of cryptocurrency.
    #
    #   Cryptocompare::PriceHistorical.find('ETH', 'USD') #=> {"ETH"=>{"USD"=>225.93}}
    #
    # Find historical price of cryptocurrency at a given timestamp.
    #
    #   Cryptocompare::PriceHistorical.find('ETH', 'USD', {'ts' => 1452680400}) #=> {"ETH"=>{"USD"=>223.2}}
    #
    # Find historical price of cryptocurrency in many currencies at a given timestamp.
    #
    #   Cryptocompare::PriceHistorical.find('ETH', ['BTC', 'USD', 'EUR'], {'ts' => '1452680400') #=> {"ETH"=>{"BTC"=>0.08006, "USD"=>225.93, "EUR"=>194.24}}
    def self.find(from_sym, to_syms, opts = {})
      tsyms = Array(to_syms).join(',')
      full_path = API_URL + "?fsym=#{from_sym}&tsyms=#{tsyms}"
      full_path += "&ts=#{opts['ts']}" if opts['ts']
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
