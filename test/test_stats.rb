require 'test_helper'

class TestStats < Minitest::Test
  RATE_LIMIT_KEYS = %w[
    Response
    Message
    HasWarning
    Type
    RateLimit
    Data
  ].freeze

  RATE_LIMIT_DATA_KEYS = %w[
    calls_made
    calls_left
  ].freeze

  RATE_LIMIT_METADATA_KEYS = %w[
    second
    minute
    hour
    day
    month
  ].freeze

  def test_rate_limit
    VCR.use_cassette('rate_limit') do
      rate_limit_resp = Cryptocompare::Stats.rate_limit
      assert_equal 'Success', rate_limit_resp['Response']
      assert rate_limit_resp.kind_of?(Hash)

      rate_limit_resp.each do |rate_limit_key, _|
        assert RATE_LIMIT_KEYS.include?(rate_limit_key)
      end

      rate_limit_resp_data = rate_limit_resp.fetch('Data')
      rate_limit_resp_data.each do |rate_limit_data_key, _|
        assert RATE_LIMIT_DATA_KEYS.include?(rate_limit_data_key)
      end

      calls_made_data = rate_limit_resp_data.fetch('calls_made')
      calls_made_data.each do |calls_made_key, calls_made_value|
        assert RATE_LIMIT_METADATA_KEYS.include?(calls_made_key)
        assert calls_made_value.kind_of?(Integer)
      end

      calls_left_data = rate_limit_resp_data.fetch('calls_left')
      calls_left_data.each do |calls_left_key, calls_left_value|
        assert RATE_LIMIT_METADATA_KEYS.include?(calls_left_key)
        assert calls_left_value.kind_of?(Integer)
      end
    end
  end
end
