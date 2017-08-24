require 'yaml'

# Helper module for exchange names.
module Cryptocompare
  module ExchangeNameHelper
    EXCHANGES = YAML::load_file(File.join(__dir__, '../../../config/exchanges.yml'))

    # Helper method to overcome case-sensitive exchange name enforced by the API.
    # If no supported exchange mapping is found, it will try user's input.
    def self.set_exchange(exchange)
      EXCHANGES[exchange.upcase] || exchange
    end
  end
end
