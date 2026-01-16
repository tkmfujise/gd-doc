require 'bundler/setup'
require 'pry'
require './lib/gd_doc'
require 'simplecov'

SimpleCov.start do
  add_group 'Formatters', 'lib/gd_doc/formatters'
  add_group 'Tree Node', 'lib/gd_doc/tree_node'
end

require_relative 'test_helper'


RSpec.configure do |config|
  config.include TestHelper
end
