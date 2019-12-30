require "pry"
require_relative '../config/environment'

toli = User.find(2)
renata = User.find(1)

binding.pry

puts "Fire types are the best starters"