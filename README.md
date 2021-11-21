# cryptocompare

[![Gem Version](https://badge.fury.io/rb/cryptocompare.svg)](http://badge.fury.io/rb/cryptocompare) [![CircleCI](https://circleci.com/gh/alexanderdavidpan/cryptocompare.svg?style=shield)](https://circleci.com/gh/alexanderdavidpan/cryptocompare)
[![Test Coverage](https://codeclimate.com/github/alexanderdavidpan/cryptocompare/badges/coverage.svg)](https://codeclimate.com/github/alexanderdavidpan/cryptocompare/coverage)

This is a Ruby gem that utilizes the CryptoCompare API to fetch data related to cryptocurrencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cryptocompare'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cryptocompare

## Usage

To use cryptocompare, just require it like so:

```ruby
require 'cryptocompare'
```

### API Keys

Some requests will require an API key. In order to obtain an API key, you will need to request one from Cryptocompare. You can then pass it in as an optional parameter in the any Cryptocompare module method like so:

```ruby
Cryptocompare::Price.find('ETH', 'USD', { api_key: 'API_KEY' })
# => {"ETH"=>{"USD"=>4714.16}}
```

### Price

Finds the currency price(s) of a given currency symbol. Really fast, 20-60 ms. Cached each 10 seconds.

**Examples:**

Convert cryptocurrency to fiat.

```ruby
Cryptocompare::Price.find('BTC', 'USD')
# => {"BTC"=>{"USD"=>2594.07}}
```

Convert fiat to cryptocurrency.

```ruby
Cryptocompare::Price.find('USD', 'BTC')
# => {"USD"=>{"BTC"=>0.0004176}}
```

Convert cryptocurrency to cryptocurrency.

```ruby
Cryptocompare::Price.find('BTC', 'ETH')
# => {"BTC"=>{"ETH"=>9.29}}
```

Convert fiat to fiat.

```ruby
Cryptocompare::Price.find('USD', 'EUR')
# => {"USD"=>{"EUR"=>0.8772}}
```

Convert multiple cryptocurrencies to multiple fiat.

```ruby
Cryptocompare::Price.find(['BTC','ETH', 'LTC'], ['USD', 'EUR', 'CNY'])
# => {"BTC"=>{"USD"=>2501.61, "EUR"=>2197.04, "CNY"=>17329.48}, "ETH"=>{"USD"=>236.59, "EUR"=>209.39, "CNY"=>1655.15}, "LTC"=>{"USD"=>45.74, "EUR"=>40.33, "CNY"=>310.5}}
```

Convert multiple fiat to multiple cryptocurrencies.

```ruby
Cryptocompare::Price.find(['USD', 'EUR'], ['BTC','ETH', 'LTC'])
# => {"USD"=>{"BTC"=>0.0003996, "ETH"=>0.004238, "LTC"=>0.02184}, "EUR"=>{"BTC"=>0.0004548, "ETH"=>0.00477, "LTC"=>0.0248}}
```

Convert prices based on exchange.

```ruby
Cryptocompare::Price.find('DASH', 'USD', {'e' => 'Kraken'})
# => {"DASH"=>{"USD"=>152.4}}
```

Get full price info (raw and display) for cryptocurrency to fiat currency.
```ruby
Cryptocompare::Price.full('BTC', 'USD')
# => {
#   "RAW" => {
#     "BTC" => {
#       "USD" => {
#         "TYPE"=>"5",
#         "MARKET"=>"CCCAGG",
#         "FROMSYMBOL"=>"BTC",
#         "TOSYMBOL"=>"USD",
#         "FLAGS"=>"4",
#         "PRICE"=>4551.84,
#         "LASTUPDATE"=>1504753702,
#         "LASTVOLUME"=>2.19e-06,
#         "LASTVOLUMETO"=>0.00995355,
#         "LASTTRADEID"=>20466080,
#         "VOLUME24HOUR"=>110449.85666195827,
#         "VOLUME24HOURTO"=>503369392.8440719,
#         "OPEN24HOUR"=>4497.45,
#         "HIGH24HOUR"=>4667.51,
#         "LOW24HOUR"=>4386.51,
#         "LASTMARKET"=>"Coinbase",
#         "CHANGE24HOUR"=>54.39000000000033,
#         "CHANGEPCT24HOUR"=>1.2093519661141388,
#         "SUPPLY"=>16549137,
#         "MKTCAP"=>75329023762.08
#       }
#     }
#   },
#   "DISPLAY" => {
#     "BTC" => {
#       "USD" => {
#         "FROMSYMBOL"=>"Ƀ",
#         "TOSYMBOL"=>"$",
#         "MARKET"=>"CryptoCompare Index",
#         "PRICE"=>"$ 4,551.84",
#         "LASTUPDATE"=>"Just now",
#         "LASTVOLUME"=>"Ƀ 0.00000219",
#         "LASTVOLUMETO"=>"$ 0.009954",
#         "LASTTRADEID"=>20466080,
#         "VOLUME24HOUR"=>"Ƀ 110,449.9",
#         "VOLUME24HOURTO"=>"$ 503,369,392.8",
#         "OPEN24HOUR"=>"$ 4,497.45",
#         "HIGH24HOUR"=>"$ 4,667.51",
#         "LOW24HOUR"=>"$ 4,386.51",
#         "LASTMARKET"=>"Coinbase",
#         "CHANGE24HOUR"=>"$ 54.39",
#         "CHANGEPCT24HOUR"=>"1.21",
#         "SUPPLY"=>"Ƀ 16,549,137",
#         "MKTCAP"=>"$ 75.33 B"
#       }
#     }
#   }
# }
```

Generate average price for cryptocurrency to fiat currency.

```ruby
Cryptocompare::Price.generate_avg('BTC', 'USD', ['Coinbase', 'Bitfinex'])
# => {
#   "RAW" => {
#     "MARKET" => "CUSTOMAGG",
#     "FROMSYMBOL" => "BTC",
#     "TOSYMBOL" => "USD",
#     "FLAGS" => 0,
#     "PRICE" => 4137.43,
#     "LASTUPDATE" => 1503454563,
#     "LASTVOLUME" => 2,
#     "LASTVOLUMETO" => 8271.98,
#     "LASTTRADEID" => 19656029,
#     "VOLUME24HOUR" => 71728.71957884016,
#     "VOLUME24HOURTO" => 279374718.3442189,
#     "OPEN24HOUR" => 3885.85,
#     "HIGH24HOUR" => 4145,
#     "LOW24HOUR" => 3583.46,
#     "LASTMARKET" => "Coinbase",
#     "CHANGE24HOUR" => 251.58000000000038,
#     "CHANGEPCT24HOUR" => 6.474259171095137
#   },
#   "DISPLAY" => {
#     "FROMSYMBOL" => "Ƀ",
#     "TOSYMBOL" => "$",
#     "MARKET" => "CUSTOMAGG",
#     "PRICE" => "$ 4,137.43",
#     "LASTUPDATE" => "Just now",
#     "LASTVOLUME" => "Ƀ 2",
#     "LASTVOLUMETO" => "$ 8,271.98",
#     "LASTTRADEID" => 19656029,
#     "VOLUME24HOUR" => "Ƀ 71,728.7",
#     "VOLUME24HOURTO" => "$ 279,374,718.3",
#     "OPEN24HOUR" => "$ 3,885.85",
#     "HIGH24HOUR" => "$ 4,145",
#     "LOW24HOUR" => "$ 3,583.46",
#     "LASTMARKET" => "Coinbase",
#     "CHANGE24HOUR" => "$ 251.58",
#     "CHANGEPCT24HOUR" => "6.47"
#   }
# }
```

Get day average price.

```ruby
Cryptocompare::Price.day_avg('BTC', 'USD')
# => {
#   "USD" => 4109.92,
#   "ConversionType" => {
#     "type" => "direct",
#     "conversionSymbol" => ""
#   }
# }
```

### PriceHistorical

Finds the price of any cryptocurrency in any other currency that you need at a given timestamp. The price comes from the daily info - so it would be the price at the end of the day GMT based on the requested timestamp. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion. Tries to get direct trading pair data, if there is none or it is more than 30 days before the ts requested, it uses BTC conversion. If the opposite pair trades we invert it (eg.: BTC-XMR)

**Examples:**

Find historical price of cryptocurrency.

```ruby
Cryptocompare::PriceHistorical.find('ETH', 'USD')
# => {"ETH"=>{"USD"=>225.93}}
```

Find historical price of cryptocurrency at a given timestamp.

```ruby
Cryptocompare::PriceHistorical.find('ETH', 'USD', {'ts' => 1452680400})
# => {"ETH"=>{"USD"=>223.2}}
```

Find historical price of cryptocurrency in many currencies at a given timestamp.

```ruby
Cryptocompare::PriceHistorical.find('ETH', ['BTC', 'USD', 'EUR'], {'ts' => '1452680400'})
# => {"ETH"=>{"BTC"=>0.08006, "USD"=>225.93, "EUR"=>194.24}}
```

### CoinList

Get general info for all the coins available on Cryptocompare's API.

**Example:**

```ruby
Cryptocompare::CoinList.all
# => {
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
```

### CoinSnapshot

Get data for a currency pair. It returns general block explorer information, aggregated data and individual data for each exchange available.

**Example:**

```ruby
Cryptocompare::CoinSnapshot.find('BTC', 'USD')
# => {
#      "Response":"Success",
#      "Message":"Total available exchanges - 107",
#      "Type":100,
#      "Data": {
#        "CoinInfo"=> {
#          "Id"=>"1182",
#          "Name"=>"BTC",
#          "FullName"=>"Bitcoin",
#          "Internal"=>"BTC",
#          "ImageUrl"=>"/media/37746251/btc.png",
#          "Url"=>"/coins/btc/overview",
#          "Algorithm"=>"SHA-256",
#          "ProofType"=>"PoW",
#          "TotalCoinsMined"=>18873906,
#          "BlockNumber"=>710736,
#          "NetHashesPerSecond"=>152163633011463750000,
#          "BlockReward"=>6.25,
#          "BlockTime"=>637,
#          "AssetLaunchDate"=>"2009-01-03",
#          "MaxSupply"=>20999999.9769,
#          "MktCapPenalty"=>0,
#          "TotalVolume24H"=>119421.69853408838,
#          "TotalTopTierVolume24H"=>119164.10371469974
#       },
#       "AggregatedData" => {
#         "TYPE"=>"5",
#         "MARKET"=>"CCCAGG",
#         "FROMSYMBOL"=>"BTC",
#         "TOSYMBOL"=>"USD",
#         "FLAGS"=>"1026",
#         "PRICE"=>59405.32,
#         "LASTUPDATE"=>1637524770,
#         "MEDIAN"=>59406,
#         "LASTVOLUME"=>0.0214,
#         "LASTVOLUMETO"=>1271.689008,
#         "LASTTRADEID"=>"aa1gpl99200btcfe",
#         "VOLUMEDAY"=>12490.619219841396,
#         "VOLUMEDAYTO"=>739844937.9215171,
#         "VOLUME24HOUR"=>14980.50732139,
#         "VOLUME24HOURTO"=>888337522.224627,
#         "OPENDAY"=>59770.02,
#         "HIGHDAY"=>60058.65,
#         "LOWDAY"=>58575.6,
#         "OPEN24HOUR"=>59502.04,
#         "HIGH24HOUR"=>60075.96,
#         "LOW24HOUR"=>58554.42,
#         "LASTMARKET"=>"coinfield",
#         "VOLUMEHOUR"=>522.9115465200042,
#         "VOLUMEHOURTO"=>31084371.054275494,
#         "OPENHOUR"=>59528.37,
#         "HIGHHOUR"=>59629.67,
#         "LOWHOUR"=>59298.19,
#         "TOPTIERVOLUME24HOUR"=>14980.50630839,
#         "TOPTIERVOLUME24HOURTO"=>888337462.2300239,
#         "CHANGE24HOUR"=>-96.72000000000116,
#         "CHANGEPCT24HOUR"=>-0.16254904873849899,
#         "CHANGEDAY"=>-364.6999999999971,
#         "CHANGEPCTDAY"=>-0.6101721230810984,
#         "CHANGEHOUR"=>-123.05000000000291,
#         "CHANGEPCTHOUR"=>-0.20670816284740018,
#         "CONVERSIONTYPE"=>"direct",
#         "CONVERSIONSYMBOL"=>"",
#         "SUPPLY"=>18873906,
#         "MKTCAP"=>1121210425579.92,
#         "MKTCAPPENALTY"=>0,
#         "CIRCULATINGSUPPLY"=>18873906,
#         "CIRCULATINGSUPPLYMKTCAP"=>1121210425579.92,
#         "TOTALVOLUME24H"=>119421.69853408838,
#         "TOTALVOLUME24HTO"=>7092699907.396162,
#         "TOTALTOPTIERVOLUME24H"=>119164.10371469974,
#         "TOTALTOPTIERVOLUME24HTO"=>7077397404.903025,
#         "IMAGEURL"=>"/media/37746251/btc.png"
#       },
#       "Exchanges":[
#         {
#           "TYPE":"2",
#           "MARKET":"LakeBTC",
#           "FROMSYMBOL":"BTC",
#           "TOSYMBOL":"USD",
#           "FLAGS":"2",
#           "PRICE":"244.37",
#           "LASTUPDATE":"1444513131",
#           "LASTVOLUME":"0.03",
#           "LASTVOLUMETO":"7.3311",
#           "LASTTRADEID":"1444513131",
#           "VOLUME24HOUR":"3599.0560000000005",
#           "VOLUME24HOURTO":"879237.6299349999",
#           "OPEN24HOUR":"243.83",
#           "HIGH24HOUR":"245.23",
#           "LOW24HOUR":"242.68"
#         },
#         ....
#       ]
#     }
#   }
```

### TopPairs

Get top pairs by volume for a currency (always uses aggregated data). The number of pairs you get is the minimum of the limit you set (default 5) and the total number of pairs available.

**Examples:**

Find top pairs by trading volume for a given currency.

```ruby
Cryptocompare::TopPairs.find('ETH')
# => {
#   "Response" => "Success",
#   "Data" => [
#     {
#       "exchange" => "CCCAGG",
#       "fromSymbol" => "ETH",
#       "toSymbol" => "USD",
#       "volume24h" => 1310705.3005027298,
#       "volume24hTo" => 288031723.3503975
#     },
#     {
#       "exchange" => "CCCAGG",
#       "fromSymbol" => "ETH",
#       "toSymbol" => "BTC",
#       "volume24h" => 978200.2198323006,
#       "volume24hTo" => 77883.06190085363
#     },
#     ...
#   ]
# }
```

### HistoMinute

Get open, high, low, close, volumefrom and volumeto for each minute of historical data. This data is only stored for 7 days, if you need more, use the hourly or daily path. It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

**Examples:**

Find historical data by minute for BTC to USD.

```ruby
Cryptocompare::HistoMinute.find('BTC', 'USD')
# => {
#   "Response" => "Success",
#   "Type" => 100,
#   "Aggregated" => true,
#   "Data" => [
#     {
#       "time" => 1502259120,
#       "close" => 3396.44,
#       "high" => 3397.63,
#       "low" => 3396.34,
#       "open" => 3397.39,
#       "volumefrom" => 98.2,
#       "volumeto" => 335485
#     },
#     {
#       "time" => 1502259300,
#       "close" => 3396.86,
#       "high" => 3396.94,
#       "low" => 3396.44,
#       "open" => 3396.44,
#       "volumefrom" => 16.581031,
#       "volumeto" => 56637.869999999995
#     },
#     ...
#   ],
#   "TimeTo" => 1502259360,
#   "TimeFrom" => 1502259120,
#   "FirstValueInArray" => true,
#   "ConversionType" => {
#     "type" => "direct",
#     "conversionSymbol" => ""
#   }
# }
```

### HistoHour

Get open, high, low, close, volumefrom and volumeto from the each hour historical data. It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

**Examples:**

Find historical data by hour for BTC to USD.

```ruby
Cryptocompare::HistoHour.find('BTC', 'USD')
# => {
#   "Response" => "Success",
#   "Type" => 100,
#   "Aggregated" => false,
#     "Data" => [
#     {
#       "time" => 1502259120,
#       "close" => 3396.44,
#       "high" => 3397.63,
#       "low" => 3396.34,
#       "open" => 3397.39,
#       "volumefrom" => 98.2,
#       "volumeto" => 335485
#     },
#     {
#       "time" => 1502259300,
#       "close" => 3396.86,
#       "high" => 3396.94,
#       "low" => 3396.44,
#       "open" => 3396.44,
#       "volumefrom" => 16.581031,
#       "volumeto" => 56637.869999999995
#     },
#     ...
#   ],
#   "TimeTo" => 1503248400,
#   "TimeFrom" => 1502643600,
#   "FirstValueInArray" => true,
#   "ConversionType" => {
#     "type" => "direct",
#     "conversionSymbol" => ""
#   }
# }
```

### HistoDay

Get open, high, low, close, volumefrom and volumeto daily historical data. The values are based on 00:00 GMT time. It uses BTC conversion if data is not available because the coin is not trading in the specified currency.

**Examples:**

Find historical data by day for BTC to USD.

```ruby
Cryptocompare::HistoDay.find('BTC', 'USD')
# => {
#   "Response" => "Success",
#   "Type" => 100,
#   "Aggregated" => false,
#   "Data" => [
#     {
#       "time" => 1500854400,
#       "close" => 2763.42,
#       "high" => 2798.89,
#       "low" => 2715.69,
#       "open" => 2756.61,
#       "volumefrom" => 83009.25,
#       "volumeto" => 229047365.02
#     },
#     {
#       "time" => 1500940800,
#       "close" => 2582.58,
#       "high" => 2779.08,
#       "low" => 2472.62,
#       "open" => 2763.42,
#       "volumefrom" => 205883.15,
#       "volumeto" => 534765380.75
#     },
#     ...
#   ],
#   "TimeTo" => 1503446400,
#   "TimeFrom" => 1500854400,
#   "FirstValueInArray" => true,
#   "ConversionType" => {
#     "type" => "direct",
#     "conversionSymbol" => ""
#   }
# }
```

## News
Get news articles from the providers that CryptoCompare has integrated with as well as news provider data.

**Example:**

Get news articles from the providers that CryptoCompare has integrated with.

```ruby
Cryptocompare::News.all
# => [
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
# ]
```

**Example:**

Get all the news providers that CryptoCompare has integrated with.

```ruby
Cryptocompare::News.providers
# => [
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
# ]
```

### Exchanges
Get exchange data, such as cryptocurrencies that each exchange offers, and the supported conversion cryptocurrencies.

**Examples:**

Get info for all exchanges.

```ruby
Cryptocompare::Exchanges.all
# => {
#   "Coinbase" => [
#      {
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
#         "BCH" => [
#            "USD"
#         ],
#         "BTC" => [
#            "USD",
#            "GBP",
#            "EUR",
#            "CAD"
#         ]
#      },
#   ],
#   ...
# }
```

## Supported Exchanges

* aax
* ABCC
* Abucoins
* ACX
* AidosMarket
* aliexchange
* alphaex
* altilly
* ataix
* bcbitcoin
* BCEX
* beldex
* bequant
* betconix
* Bgogo
* bhex
* Bibox
* BigONE
* biki
* bilaxy
* Binance
* binancedex
* Binanceje
* binanceusa
* bingcoins
* Bit2C
* bitasset
* BitBank
* BitBay
* bitbuy
* bitci
* bitcoincom
* BitexBook
* bitfex
* Bitfinex
* BitFlip
* bitFlyer
* bitflyereu
* bitFlyerFX
* bitflyerus
* Bitforex
* BitGrail
* Bithumb
* bithumbglobal
* Bitinfi
* Bitkub
* Bitlish
* BitMarket
* BitMart
* bitmax
* Bitmex
* bitpanda
* Bitpoint
* Bitsane
* Bitshares
* Bitso
* bitspark
* BitSquare
* Bitstamp
* BitTrex
* BitZ
* bkex
* Blackturtle
* Bleutrade
* blockchaincom
* Bluebelt
* Braziliex
* BTC38
* BTCAlpha
* BTCBOX
* BTCChina
* BTCE
* BTCExchange
* BTCMarkets
* btcmex
* BTCTurk
* btcXchange
* BTCXIndia
* BTER
* btse
* Buda
* bw
* BXinth
* bybit
* Catex
* CBX
* CCCAGG
* CCEDK
* CCEX
* Cexio
* chainrift
* chainx
* chaoex
* CHBTC
* ChileBit
* cobinhood
* Codex
* coinall
* Coinbase
* CoinBene
* Coincap
* Coincheck
* CoinCorner
* CoinDeal
* coineal
* coinegg
* CoinEx
* CoinFalcon
* coinfield
* Coinfloor
* CoinHub
* CoinJar
* Coinmate
* Coinnest
* Coinone
* CoinPulse
* Coinroom
* CoinsBank
* Coinsbit
* Coinse
* Coinsetter
* coinspro
* coinsuper
* CoinTiger
* coinzest
* compound
* coss
* crex24
* crosstower
* Cryptagio
* CryptoBulls
* CryptoCarbon
* cryptodotcom
* CryptoExchangeWS
* cryptofacilities
* cryptonex
* Cryptonit
* Cryptopia
* CryptoX
* Cryptsy
* currency
* curve
* darbfinance
* dcoin
* DDEX
* decoin
* deribit
* DEx
* DigiFinex
* DSX
* e55com
* eidoo
* equos
* erisx
* EtherDelta
* Ethermium
* EthexIndia
* Ethfinex
* etoro
* Everbloom
* Exenium
* Exmo
* EXRATES
* exscudo
* ExtStock
* EXX
* fatbtc
* FCCE
* FCoin
* Foxbit
* ftx
* ftxus
* Gatecoin
* Gateio
* Gemini
* Globitex
* Gneiss
* Gnosis
* gopax
* Graviex
* HADAX
* hbus
* Hikenex
* HitBTC
* Huobi
* huobifutures
* huobijapan
* huobikorea
* HuobiPro
* iCoinbay
* IDAX
* idevex
* IDEX
* Incorex
* IndependentReserve
* indodax
* InstantBitex
* IQFinex
* Ironex
* itBit
* Jubi
* Korbit
* Kraken
* Kucoin
* Kuna
* LakeBTC
* LAToken
* LBank
* Liqnet
* Liqui
* Liquid
* LiveCoin
* lmax
* LocalBitcoins
* Luno
* Lykke
* MercadoBitcoin
* Minebit
* MonetaGo
* MtGox
* NDAX
* Nebula
* Neraex
* Nexchange
* Nlexch
* nominex
* Novaexchange
* Nuex
* oex
* OKCoin
* OKEX
* onederx
* oneinch
* OpenLedger
* Ore
* P2PB2B
* pancakeswap
* paribu
* Paymium
* Poloniex
* primexbt
* probit
* Qryptos
* QuadrigaCX
* quickswap
* Quoine
* raidofinance
* Remitano
* RightBTC
* SafeCoin
* safetrade
* seedcx
* sigenp2p
* sigenpro
* Simex
* SingularityX
* sistemkoin
* slicex
* smartrade
* StocksExchange
* StocksExchangeio
* Surbitcoin
* sushiswap
* Switcheo
* tchapp
* TDAX
* TheRockTrading
* thore
* Threexbit
* Tidex
* timex
* Tokenomy
* tokensnet
* TokenStore
* tokok
* TradeSatoshi
* TrustDEX
* trxmarket
* TuxExchange
* uniswap
* uniswapv2
* uniswapv3
* unnamed
* Unocoin
* Upbit
* utorg
* valr
* Vaultoro
* VBTC
* Velox
* ViaBTC
* WavesDEX
* wbb
* WEX
* WorldCryptoCap
* xbtpro
* xcoex
* xena
* XS2
* xtpub
* Yacuna
* Yobit
* Yunbi
* Zaif
* ZB
* ZBG
* zebitex
* Zecoex
* zloadr

If no exchange option is specified, then the default 'CCCAGG' is used. This is cryptocompare's aggregated data.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexanderdavidpan/cryptocompare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
