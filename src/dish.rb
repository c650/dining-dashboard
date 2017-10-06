#!/usr/bin/env ruby

class Dish
	attr_reader :name, :description
	attr_accessor :flagged

	def initialize(name, description, flagged = false)
		@name = name
		@description = description
		@flagged = flagged
	end

	def to_s
		"#{@name}: #{@description}"
	end
end
