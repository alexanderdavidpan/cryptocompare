require 'faraday'
require 'json'

module Cryptocompare
  module CoinList
    API_URL = 'https://min-api.cryptocompare.com/data/all/coinlist'.freeze
    private_constant :API_URL

    # Get general info for all the coins available on Cryptocompare's API.
    #
    # ==== Returns
    #
    # [Hash] Hash with data Data key which is a hash where coin symbols are the
    #        keys and each coin object cointains metadata about each coin.
    #
    # ==== Example
    #
    # Get all coins supported by Cryptocompare's API.
    #
    #   Cryptocompare::CoinList.all
    #
    # Sample response
    #
    #   {
    #     "Response" => "Success",
    #     "Message" => "Coin list succesfully returned!",
    #     "BaseImageUrl" => "https://www.cryptocompare.com",
    #     "BaseLinkUrl" => "https://www.cryptocompare.com",
    #     "DefaultWatchlist" => {
    #       "CoinIs" => "1182,7605,5038,24854,3807,3808,202330,5324,5031,20131",
    #       "Sponsored" => ""
    #     },
    #     "Data" => {
    #       "BTC" => {
    #         "Id" => "1182",
    #         "Url" => "/coins/btc/overview",
    #         "ImageUrl" => "/media/19633/btc.png",
    #         "Name" => "BTC",
    #         "Symbol" => "BTC",
    #         "CoinName" => "Bitcoin",
    #         "FullName" => "Bitcoin (BTC)",
    #         "Algorithm" => "SHA256",
    #         "ProofType" => "PoW",
    #         "FullyPremined" => "0",
    #         "TotalCoinSupply" => "21000000",
    #         "PreMinedValue" => "N/A",
    #         "TotalCoinsFreeFloat" => "N/A",
    #         "SortOrder" => "1",
    #         "Sponsored" => false
    #       },
    #       "ETH" => {
    #         "Id" => "7605",
    #         "Url" => "/coins/eth/overview",
    #         "ImageUrl" => "/media/20646/eth_logo.png",
    #         "Name" => "ETH",
    #         "Symbol" => "ETH",
    #         "CoinName" => "Ethereum ",
    #         "FullName" => "Ethereum (ETH)",
    #         "Algorithm" => "Ethash",
    #         "ProofType" => "PoW",
    #         "FullyPremined" => "0",
    #         "TotalCoinSupply" => "0",
    #         "PreMinedValue" => "N/A",
    #         "TotalCoinsFreeFloat" => "N/A",
    #         "SortOrder" => "2",
    #         "Sponsored" => false
    #       },
    #       ...
    #     },
    #     "Type" => 100
    #   }
    def self.all
      api_resp = Faraday.get(API_URL)
      JSON.parse(api_resp.body)
    end
  end
end
