require 'faraday'
require 'json'

module Cryptocompare
  module News
    NEWS_API_URL = 'https://min-api.cryptocompare.com/data/news/'.freeze
    private_constant :NEWS_API_URL

    NEWS_PROVIDERS_API_URL = 'https://min-api.cryptocompare.com/data/news/providers'.freeze
    private_constant :NEWS_PROVIDERS_API_URL

    # Returns news articles from the providers that CryptoCompare has integrated
    # with.
    #
    # ==== Returns
    #
    # [Array] Array of news article objects.
    #
    # ==== Example
    #
    # Get news articles from the providers that CryptoCompare has integrated
    # with.
    #
    #   Cryptocompare::News.all
    #
    # Sample response
    #
    #   [
    #     {
    #       "id" => "85721",
    #       "guid" => "https://news.bitcoin.com/?p=127153",
    #       "published_on" => 1520834400,
    #       "imageurl" => "https://images.cryptocompare.com/news/bitcoin.com/b9MBw3g640c.jpeg",
    #       "title" => "Study Finds $3B Worth of Faked Cryptocurrency Volumes and Wash Trades",
    #       "url" => "https://news.bitcoin.com/study-finds-3b-worth-of-faked-cryptocurrency-volumes-and-wash-trades/",
    #       "source" => "bitcoin.com",
    #       "body" => "On March 10 a cryptocurrency trader and researcher published a report on how he believes $3 billion worth of cryptocurrency trade volumes, primarily from a couple of exchanges, are concocted. The author of the study, Sylvain Ribes, alleges that the exchange Okcoin has been fabricating up to 93 percent of its trade volumes. Also read: Thailand [&#8      230;]The post Study Finds $3B Worth of Faked Cryptocurrency Volumes and Wash Trades appeared first on Bitcoin News.",
    #       "tags" => "News|95%|altcoin exchange|Binance|Bitcoin|BTC|Coinmarketcap|Fake Trades|GDAX|Huobi|illiquid assets|Kraken|Liquidity|Livecoinwatch|N-Featured|OKcoin|Okex|Poloniex|Sylvain Ribes|trading|Volumes|Wash Trades|Zhao Changpeng",
    #       "categories" => "BTC|Exchange|Trading",
    #       "lang" => "EN",
    #       "source_info" => {
    #         "name" => "Bitcoin.com",
    #         "lang" => "EN",
    #         "img" => "https://images.cryptocompare.com/news/default/bitcoincom.png"
    #       }
    #     },
    #     ...
    #   ]
    def self.all
      api_resp = Faraday.get(NEWS_API_URL)
      JSON.parse(api_resp.body)
    end

    # Returns all the news providers that CryptoCompare has integrated with.
    #
    # ==== Returns
    #
    # [Array] Array of news provider objects.
    #
    # ==== Example
    #
    # Get all the news providers that CryptoCompare has integrated with.
    #
    #   Cryptocompare::News.providers
    #
    # Sample response
    #
    #   [
    #     {
    #       "key" => "cryptocompare",
    #       "name" => "CryptoCompare",
    #       "lang" => "EN",
    #       "img" => "https://images.cryptocompare.com/news/default/cryptocompare.png"
    #     },
    #     {
    #       "key" => "coindesk",
    #       "name" => "CoinDesk",
    #       "lang" => "EN",
    #       "img" => "https://images.cryptocompare.com/news/default/coindesk.png"
    #     },
    #     {
    #       "key" => "bitcoinmagazine",
    #       "name" => "Bitcoin Magazine",
    #       "lang" => "EN",
    #       "img" => "https://images.cryptocompare.com/news/default/bitcoinmagazine.png"
    #     },
    #     {
    #       "key" => "yahoofinance",
    #       "name" => "Yahoo Finance Bitcoin",
    #       "lang" => "EN",
    #       "img" => "https://images.cryptocompare.com/news/default/yahoofinance.png"
    #     },
    #     ...
    #   ]
    def self.providers
      api_resp = Faraday.get(NEWS_PROVIDERS_API_URL)
      JSON.parse(api_resp.body)
    end
  end
end
