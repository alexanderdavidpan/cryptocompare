# Cryptocompare

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

To use Cryptocompare, just require it like so:

```ruby
require 'cryptocompare'
```

Examples:

1. Cryptocurrency to Fiat

```ruby
Cryptocompare::Price.find('BTC', 'USD')
# => {"BTC"=>{"USD"=>2594.07}}
```

2. Fiat to Cryptocurrency

```ruby
Cryptocompare::Price.find('USD', 'BTC')
# => {"USD"=>{"BTC"=>0.0004176}}
```
3. Cryptocurrency to Cryptocurrency

```ruby
Cryptocompare::Price.find('BTC', 'ETH')
# =>{"BTC"=>{"ETH"=>9.29}}
```

4. Fiat to Fiat

```ruby
Cryptocompare::Price.find('USD', 'EUR')
# => {"USD"=>{"EUR"=>0.8772}}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cryptocompare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
