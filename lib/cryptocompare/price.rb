module Cryptocompare
  API_URL = 'https://min-api.cryptocompare.com/data/price'

  class Price
    # Finds the currency price(s) of a given cryptocurrency symbol
    #
    # Params:
    # cc_sym [String]        - cryptocurrency symbols  (ex: 'BTC', 'ETH', 'LTC')
    # c_sym  [String, Array] - currency symbols (ex: 'USD', 'EUR', 'CNY')
    #
    # Returns:
    # [Hash] Hash with cryptocurrency currency prices
    #
    # Examples:
    # Cryptocompare::Price.find('BTC', 'USD')
    # {"BTC"=>{"USD"=>2594.07}}
    #
    # Cryptocompare::Price.find('ETH', ['USD', 'EUR'])
    # => {"ETH"=>{"USD"=>305.26, "EUR"=>271.15}}
    def self.find(cc_sym, c_syms)
      tsyms = Array(c_syms).join(',')
      full_path = API_URL + "?fsym=#{cc_sym}&tsyms=#{tsyms}"
      api_resp = Faraday.get(full_path)
      prices_resp = JSON.parse(api_resp.body)
      { cc_sym => prices_resp }
    end
  end
end
