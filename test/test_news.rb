require 'test_helper'

class TestNews < Minitest::Test
  NEWS_KEYS = %w[
    id
    guid
    published_on
    imageurl
    title
    url
    source
    body
    tags
    lang
    source_info
  ].freeze

  NEWS_PROVIDERS_KEYS = %w[
    key
    name
    lang
    img
  ].freeze

  def test_news_all
    VCR.use_cassette('all_news') do
      all_news_resp = Cryptocompare::News.all

      assert all_news_resp.kind_of?(Array)

      all_news_resp.each do |news_obj|
        NEWS_KEYS.each do |news_key|
          assert news_obj.has_key?(news_key)
        end
      end
    end
  end

  def test_news_providers
    VCR.use_cassette('news_providers') do
      news_providers_resp = Cryptocompare::News.providers

      assert news_providers_resp.kind_of?(Array)

      news_providers_resp.each do |news_provider|
        NEWS_PROVIDERS_KEYS.each do |news_provider_key|
          assert news_provider.has_key?(news_provider_key)
        end
      end
    end
  end
end
