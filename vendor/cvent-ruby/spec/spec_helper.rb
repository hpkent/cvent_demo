require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'

require_relative '../lib/cvent'

require 'turn'

Turn.config do |c|
  c.format = :outline
  c.trace = true
  c.natural = true
end
