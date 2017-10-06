#!/usr/bin/env ruby

require_relative "../src/grabber.rb"

result = Grabber.grab("knightro\'s")

puts result.read
