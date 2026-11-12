# frozen_string_literal: true

require 'chefspec'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'windows'
  config.version = '2022'
end
