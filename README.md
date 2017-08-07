# cryptocompare

[![Gem Version](https://badge.fury.io/rb/cryptocompare.svg)](http://badge.fury.io/rb/cryptocompare) [![Build Status](https://travis-ci.org/alexanderdavidpan/cryptocompare.svg)](https://travis-ci.org/alexanderdavidpan/cryptocompare)


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

### CoinSnapshot

Get data for a currency pair. It returns general block explorer information, aggregated data and individual data for each exchange available.

**Example:**

```ruby
Cryptocompare::CoinSnapshot.find('BTC', 'USD')
# => {
#     "Response":"Success",
#     "Message":"Coin snapshot succesfully returned",
#     "Type":100,
#     "Data":{
#       "Algorithm":"SHA256",
#       "ProofType":"PoW",
#       "BlockNumber":378345,
#       "NetHashesPerSecond":465548431.66333866,
#       "TotalCoinsMined":14707625.0,
#       "BlockReward":25.0,
#       "AggregatedData":{
#         "TYPE":"5",
#         "MARKET":"CCCAGG",
#         "FROMSYMBOL":"BTC",
#         "TOSYMBOL":"USD",
#         "FLAGS":"4",
#         "PRICE":"245.41",
#         "LASTUPDATE":"1444520460",
#         "LASTVOLUME":"0.0086",
#         "LASTVOLUMETO":"2.110268",
#         "LASTTRADEID":"1444520460357",
#         "VOLUME24HOUR":"49591.48108707269",
#         "VOLUME24HOURTO":"12139110.189163648",
#         "OPEN24HOUR":"244.41",
#         "HIGH24HOUR":"258.37",
#         "LOW24HOUR":"239.01000004",
#         "LASTMARKET":"Huobi"
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
#   Response: "Success",
#   Data: [
#     {
#       exchange: "CCCAGG",
#       fromSymbol: "ETH",
#       toSymbol: "USD",
#       volume24h: 1310705.3005027298,
#       volume24hTo: 288031723.3503975
#     },
#     {
#       exchange: "CCCAGG",
#       fromSymbol: "ETH",
#       toSymbol: "BTC",
#       volume24h: 978200.2198323006,
#       volume24hTo: 77883.06190085363
#     },
#     ...
#   ]
# }
```

## Supported Exchanges

* BTC38
* BTCC
* BTCE
* BTCMarkets
* BTCXIndia
* BTER
* Bit2C
* BitBay
* bitFlyer
* bitFlyerFX
* BitMarket
* BitSquare
* Bitfinex
* Bitso
* Bitstamp
* Bittrex
* Bleutrade
* CCEDK
* Cexio
* CoinCheck
* Coinbase
* Coinfloor
* Coinone
* Coinse
* Coinsetter
* Cryptopia
* Cryptsy
* EtherDelta
* EthexIndia
* Gatecoin
* Gemini
* HitBTC
* Huobi
* itBit
* Korbit
* Kraken
* LakeBTC
* Liqui
* LiveCoin
* LocalBitcoins
* Luno
* MercadoBitcoin
* MonetaGo
* OKCoin
* Paymium
* Poloniex
* QuadrigaCX
* Quoine
* TheRockTrading
* Tidex
* Unocoin
* Vaultoro
* Yacuna
* Yobit
* Yunbi

If no exchange option is specified, then the default 'CCCAGG' is used. This is cryptocompare's aggregated data.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alexanderdavidpan/cryptocompare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
