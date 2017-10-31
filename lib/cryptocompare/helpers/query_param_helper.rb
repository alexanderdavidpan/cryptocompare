require 'yaml'

# Helper module for setting query params.
module Cryptocompare
  module QueryParamHelper
    QUERY_PARAM_MAPPING = YAML::load_file(File.join(__dir__, '../../../config/query_param_mapping.yml'))

    # Appends query parameters to path
    def self.set_query_params(path, opts)
      path + "?#{to_query(opts)}"
    end

    # Helper method to parse parameters and build query parameters
    def self.to_query(opts)
      opts.collect do |key, value|
        "#{QUERY_PARAM_MAPPING[key]}=#{value}"
      end.sort * '&'
    end
  end
end
