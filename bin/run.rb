require "pry"
require_relative '../config/environment'

cli = CLI.new

cli.opening_credits
cli.greet_user

# ruby ./cli.rb

# binding.pry

# puts "Fire types are the best starters"