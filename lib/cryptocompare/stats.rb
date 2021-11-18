require 'faraday'
require 'json'

module Cryptocompare
  module Stats
    API_URL = 'https://min-api.cryptocompare.com/stats/rate/limit'.freeze
    private_constant :API_URL

    # Find out how many calls you have left in the current month, day, hour, minute and second
    #
    # ==== Returns
    #
    # [Hash] Returns a hash containing data about calls_made and calls_left
    #
    # ==== Examples
    #
    # Find out how calls you have made and have left in the current month, day, hour, minute and second
    #
    #   Cryptocompare::Stats.rate_limit
    #
    # Sample response
    #
    # TODO
    def self.rate_limit
      api_resp = Faraday.get(API_URL)
      JSON.parse(api_resp.body)
    end
  end
end
