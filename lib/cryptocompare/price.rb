module Cryptocompare
  API_URL = 'https://min-api.cryptocompare.com/data/pricemulti'

  class Price
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
    # => {"BTC"=>{"ETH"=>9.29}}
    #
    # 4. Fiat to Fiat
    # Cryptocompare::Price.find('USD', 'EUR')
    # => {"USD"=>{"EUR"=>0.8772}}
    def self.find(from_syms, to_syms)
      fsyms = Array(from_syms).join(',')
      tsyms = Array(to_syms).join(',')
      full_path = API_URL + "?fsyms=#{fsyms}&tsyms=#{tsyms}"
      api_resp = Faraday.get(full_path)
      JSON.parse(api_resp.body)
    end
  end
end
