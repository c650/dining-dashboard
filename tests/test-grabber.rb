#!/usr/bin/env ruby

require_relative "../src/grabber.rb"

puts Grabber.make_link("knightro\'s")

result = Grabber.grab("knightro\'s")

puts result.read
