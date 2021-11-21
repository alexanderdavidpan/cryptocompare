require 'faraday'
require 'json'

module Cryptocompare
  module Exchanges
    API_URL = 'https://min-api.cryptocompare.com/data/all/exchanges'.freeze
    private_constant :API_URL

    # Get exchange data, such as cryptocurrencies that each exchange offers, and
    # the supported conversion cryptocurrencies.
    #
    # ==== Returns
    #
    # [Hash] Hash of exchanges, cryptocurrencies that each exchange offers, and
    # the supported conversion cryptocurrencies.
    #
    # ==== Example
    #
    # Get info for all exchanges.
    #
    #   Cryptocompare::Exchanges.all
    #
    # Sample response
    #
    #   {
    #      "Coinbase" => {
    #         "LTC" => [
    #            "BTC",
    #            "USD",
    #            "EUR"
    #         ],
    #         "ETH" => [
    #            "BTC",
    #            "USD",
    #            "EUR"
    #         ],
    #         "BTC" => [
    #            "USD",
    #            "GBP",
    #            "EUR",
    #            "CAD"
    #         ],
    #         "BCH" => [
    #            "USD"
    #         ]
    #      },
    #      ...
    #   }
    def self.all
      api_resp = Faraday.get(API_URL)
      JSON.parse(api_resp.body)
    end
  end
end
