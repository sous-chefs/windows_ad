require 'chefspec'
require 'chefspec/berkshelf'

# at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  config.color = true
  config.log_level = :error
  config.platform = 'windows'
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end
